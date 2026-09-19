#!/bin/bash
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/coder-dotfiles"
PROJECT_DIR="${PROJECT_DIR:-/workspaces/shares}"

# Every tool below installs into ~/.local/bin.
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

failed=()

# install <name> <binary> <installer url> <shell>
install() {
    local name="$1" binary="$2" url="$3" shell="$4"

    if command -v "$binary" &> /dev/null; then
        echo "==> $name already installed, skipping"
        return
    fi

    echo "==> Installing $name..."
    if ! curl -fsSL "$url" | "$shell" || ! command -v "$binary" &> /dev/null; then
        echo "Warning: $name installation failed" >&2
        failed+=("$name")
    fi
}

# fetch_release <repo> <asset> <binaries...>
# Downloads <asset> from the latest GitHub release of <repo> and copies the
# binaries out of it. TAG and VERSION in <asset> are replaced with the release
# tag (v1.2.3) and the tag without its leading "v" (1.2.3).
fetch_release() {
    local repo="$1" asset="$2"
    shift 2

    # Resolve the tag via the releases/latest redirect to avoid API rate limits.
    local tag
    tag="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$repo/releases/latest")" || return 1
    tag="${tag##*/}"
    asset="${asset//VERSION/${tag#v}}"
    asset="${asset//TAG/$tag}"

    local tmp
    tmp="$(mktemp -d)" || return 1
    curl -fsSL "https://github.com/$repo/releases/download/$tag/$asset" -o "$tmp/$asset" || return 1
    mkdir "$tmp/out"
    case "$asset" in
        *.zip)
            if command -v unzip &> /dev/null; then
                unzip -q "$tmp/$asset" -d "$tmp/out" || return 1
            else
                python3 -m zipfile -e "$tmp/$asset" "$tmp/out" || return 1
            fi
            ;;
        *) tar -xzf "$tmp/$asset" -C "$tmp/out" || return 1 ;;
    esac

    local binary path
    for binary in "$@"; do
        path="$(find "$tmp/out" -type f -name "$binary" | head -n 1)"
        [ -n "$path" ] || return 1
        command install -m 755 "$path" "$BIN_DIR/$binary" || return 1
    done
    rm -rf "$tmp"
}

# install_release <name> <repo> <asset> <binaries...>
install_release() {
    local name="$1"
    shift

    if command -v "$3" &> /dev/null; then
        echo "==> $name already installed, skipping"
        return
    fi

    echo "==> Installing $name..."
    if ! fetch_release "$@"; then
        echo "Warning: $name installation failed" >&2
        failed+=("$name")
    fi
}

# AI coding agents
export CODEX_NON_INTERACTIVE=1
export UNPEEL_INSTALL_DIR="$BIN_DIR"

install "Claude Code" claude       https://claude.ai/install.sh         bash
install "Codex"       codex        https://chatgpt.com/codex/install.sh sh
install "Cursor CLI"  cursor-agent https://cursor.com/install           bash
install "Unpeel"      unpeel       https://unpeel.com/install.sh        sh

# Review and navigation tools (prebuilt Linux binaries from GitHub releases)
case "$(uname -s)-$(uname -m)" in
    Linux-x86_64 | Linux-amd64)
        rust_arch=x86_64 go_arch=amd64 lazygit_arch=x86_64
        delta_target=x86_64-unknown-linux-musl
        ;;
    Linux-aarch64 | Linux-arm64)
        rust_arch=aarch64 go_arch=arm64 lazygit_arch=arm64
        delta_target=aarch64-unknown-linux-gnu
        ;;
    *) rust_arch="" ;;
esac

if [ -n "$rust_arch" ]; then
    musl="$rust_arch-unknown-linux-musl"
    install_release "lazygit" jesseduffield/lazygit "lazygit_VERSION_linux_$lazygit_arch.tar.gz" lazygit
    install_release "delta"   dandavison/delta      "delta-VERSION-$delta_target.tar.gz"         delta
    install_release "yazi"    sxyazi/yazi           "yazi-$musl.zip"                             yazi ya
    install_release "fzf"     junegunn/fzf          "fzf-VERSION-linux_$go_arch.tar.gz"          fzf
    install_release "fd"      sharkdp/fd            "fd-TAG-$musl.tar.gz"                        fd
    install_release "bat"     sharkdp/bat           "bat-TAG-$musl.tar.gz"                       bat
    install_release "ripgrep" BurntSushi/ripgrep    "ripgrep-VERSION-$musl.tar.gz"               rg
    install_release "fresh"   sinelaw/fresh         "fresh-editor-$musl.tar.gz"                  fresh
else
    echo "Warning: unsupported platform $(uname -sm), skipping review and navigation tools" >&2
fi

# TypeScript/JavaScript language server for Fresh (go to definition, diagnostics).
# typescript is pinned to 6.x: it is the server's fallback when the folder opened
# in Fresh has no node_modules/typescript (monorepos), and 7.x no longer ships
# the lib/tsserver.js the server needs.
if command -v typescript-language-server &> /dev/null && [ -f "$HOME/.local/lib/node_modules/typescript/lib/tsserver.js" ]; then
    echo "==> typescript-language-server already installed, skipping"
elif command -v npm &> /dev/null; then
    echo "==> Installing typescript-language-server..."
    # --prefix puts the binaries in ~/.local/bin without sudo.
    if ! npm install -g --prefix "$HOME/.local" typescript-language-server typescript@6; then
        echo "Warning: typescript-language-server installation failed" >&2
        failed+=("typescript-language-server")
    fi
else
    echo "Warning: npm not found, skipping typescript-language-server" >&2
fi

# Unpeel only shares $HOME and registered projects with the app, so register
# the workspace project, which lives outside $HOME.
if command -v unpeel &> /dev/null && [ -d "$PROJECT_DIR" ]; then
    if unpeel projects list 2> /dev/null | grep -qF "$PROJECT_DIR"; then
        echo "==> Unpeel project $PROJECT_DIR already registered, skipping"
    else
        echo "==> Registering $PROJECT_DIR as an Unpeel project..."
        if ! unpeel add "$PROJECT_DIR" --name "$(basename "$PROJECT_DIR")"; then
            echo "Warning: could not register $PROJECT_DIR with Unpeel" >&2
            failed+=("Unpeel project")
        fi
    fi
fi

# Syntax-highlighted diffs for plain git commands.
if command -v delta &> /dev/null; then
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.line-numbers true
    git config --global merge.conflictStyle zdiff3
fi

# lazygit: render diffs with delta, open files in fresh.
if [ ! -e "$HOME/.config/lazygit/config.yml" ]; then
    mkdir -p "$HOME/.config/lazygit"
    cp "$DOTFILES_DIR/lazygit.yml" "$HOME/.config/lazygit/config.yml"
fi

# Fresh: Alt-free keys, since the Unpeel terminal sends Option as a character.
if [ ! -e "$HOME/.config/fresh/config.json" ]; then
    mkdir -p "$HOME/.config/fresh"
    cp "$DOTFILES_DIR/fresh.json" "$HOME/.config/fresh/config.json"
fi

# PATH, $EDITOR and the ff/fs/y/lg helpers for future shell sessions.
mkdir -p "$CONFIG_DIR"
cp "$DOTFILES_DIR/shellrc.sh" "$CONFIG_DIR/shellrc.sh"

marker="# Coder dotfiles: shell setup"
for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if ! grep -qF "$marker" "$shell_rc" 2>/dev/null; then
        printf '\n%s\n[ -f "%s" ] && . "%s"\n' "$marker" "$CONFIG_DIR/shellrc.sh" "$CONFIG_DIR/shellrc.sh" >> "$shell_rc"
    fi
done

if [ ${#failed[@]} -gt 0 ]; then
    echo "==> Finished with failures: ${failed[*]}" >&2
    exit 1
fi

echo "==> Installation complete!"
