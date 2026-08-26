#!/bin/bash
set -e

echo "==> Installing AI coding CLI tools..."

# Cursor CLI lands in ~/.local/bin.
export PATH="$HOME/.local/bin:$PATH"

# Codex (OpenAI CLI)
if command -v codex &> /dev/null; then
    echo "==> Codex already installed, skipping"
elif command -v npm &> /dev/null; then
    echo "==> Installing Codex..."
    sudo npm install -g @openai/codex
else
    echo "Warning: npm not found, skipping Codex installation"
fi

# Opencode
if command -v opencode &> /dev/null; then
    echo "==> Opencode already installed, skipping"
else
    echo "==> Installing Opencode..."
    curl -fsSL https://opencode.ai/install | bash
fi

# Cursor CLI (https://cursor.com/cli)
if command -v agent &> /dev/null; then
    echo "==> Cursor CLI already installed, skipping"
else
    echo "==> Installing Cursor CLI..."
    curl https://cursor.com/install -fsS | bash
fi

ensure_local_bin_path() {
    local shell_rc="$1"
    local marker="# Coder dotfiles: add ~/.local/bin to PATH"

    if ! grep -q "$marker" "$shell_rc" 2>/dev/null; then
        echo "==> Adding ~/.local/bin to PATH in $shell_rc..."
        cat >> "$shell_rc" << 'SHELLRC'

# Coder dotfiles: add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"
SHELLRC
    fi
}

# Strip the old git push --no-verify wrapper from previous dotfiles installs.
remove_git_push_no_verify() {
    local shell_rc="$1"
    local marker="# Coder dotfiles: disable pre-push hooks"
    local tmp

    if [ ! -f "$shell_rc" ] || ! grep -q "$marker" "$shell_rc"; then
        return 0
    fi

    echo "==> Removing git push wrapper from $shell_rc..."
    tmp="$(mktemp)"
    awk -v marker="$marker" '
        index($0, marker) { skip=1; next }
        skip {
            if ($0 == "}") { skip=0 }
            next
        }
        { print }
    ' "$shell_rc" > "$tmp" && mv "$tmp" "$shell_rc"
}

ensure_local_bin_path "$HOME/.bashrc"
ensure_local_bin_path "$HOME/.zshrc"
remove_git_push_no_verify "$HOME/.bashrc"
remove_git_push_no_verify "$HOME/.zshrc"

echo "==> AI coding tools installation complete!"
