#!/bin/bash
set -e

echo "==> Installing AI coding CLI tools..."

# Claude Code (native installer - recommended, auto-updates)
if command -v claude &> /dev/null; then
    echo "==> Claude Code already installed, skipping"
else
    echo "==> Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

# Codex (OpenAI CLI)
if command -v codex &> /dev/null; then
    echo "==> Codex already installed, skipping"
elif command -v npm &> /dev/null; then
    echo "==> Installing Codex..."
    npm install -g @openai/codex
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

echo "==> AI coding tools installation complete!"
