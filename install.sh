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

# Neovim
if command -v nvim &> /dev/null; then
    echo "==> Neovim already installed, skipping"
else
    echo "==> Installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm -f nvim-linux-x86_64.tar.gz
fi

# Lazygit (git TUI, used by LazyVim's Space+gg)
if command -v lazygit &> /dev/null; then
    echo "==> Lazygit already installed, skipping"
else
    echo "==> Installing Lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduber/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduber/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
fi

# Neovim config (LazyVim)
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "==> Neovim config already exists, skipping"
else
    echo "==> Installing LazyVim starter config..."
    git clone https://github.com/LazyVim/starter.git "$NVIM_CONFIG_DIR"
    rm -rf "$NVIM_CONFIG_DIR/.git"
fi

echo "==> AI coding tools installation complete!"
