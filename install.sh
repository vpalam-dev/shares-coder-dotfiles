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

ensure_local_bin_path "$HOME/.bashrc"
ensure_local_bin_path "$HOME/.zshrc"

echo "==> AI coding tools installation complete!"
