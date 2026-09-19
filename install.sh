#!/bin/bash
set -uo pipefail

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

export CODEX_NON_INTERACTIVE=1
export UNPEEL_INSTALL_DIR="$BIN_DIR"

install "Claude Code" claude       https://claude.ai/install.sh         bash
install "Codex"       codex        https://chatgpt.com/codex/install.sh sh
install "Cursor CLI"  cursor-agent https://cursor.com/install           bash
install "Unpeel"      unpeel       https://unpeel.com/install.sh        sh

# Make ~/.local/bin available in future shell sessions.
marker="# Coder dotfiles: add ~/.local/bin to PATH"
for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if ! grep -qF "$marker" "$shell_rc" 2>/dev/null; then
        printf '\n%s\nexport PATH="$HOME/.local/bin:$PATH"\n' "$marker" >> "$shell_rc"
    fi
done

if [ ${#failed[@]} -gt 0 ]; then
    echo "==> Finished with failures: ${failed[*]}" >&2
    exit 1
fi

echo "==> AI coding tools installation complete!"
