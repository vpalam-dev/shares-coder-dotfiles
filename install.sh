#!/bin/bash
set -e

echo "==> Installing AI coding CLI tools..."

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

# Disable pre-push hooks for interactive shells in Coder.
configure_git_push_no_verify() {
    local shell_rc="$1"
    local marker="# Coder dotfiles: disable pre-push hooks"

    if ! grep -q "$marker" "$shell_rc" 2>/dev/null; then
        echo "==> Configuring git push to skip pre-push hooks in $shell_rc..."
        cat >> "$shell_rc" << 'SHELLRC'

# Coder dotfiles: disable pre-push hooks
git() {
    if [ "$1" = "push" ]; then
        shift
        command git push --no-verify "$@"
    else
        command git "$@"
    fi
}
SHELLRC
    fi
}

configure_git_push_no_verify "$HOME/.bashrc"
configure_git_push_no_verify "$HOME/.zshrc"

echo "==> AI coding tools installation complete!"
