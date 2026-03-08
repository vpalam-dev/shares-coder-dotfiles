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

# Neovim config (kickstart.nvim)
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [ -d "$NVIM_CONFIG_DIR/.git" ]; then
    echo "==> Neovim config already exists, skipping"
else
    echo "==> Installing kickstart.nvim config..."
    rm -rf "$NVIM_CONFIG_DIR"
    git clone https://github.com/nvim-lua/kickstart.nvim.git "$NVIM_CONFIG_DIR"

    # Enable neo-tree file browser
    sed -i "s|-- require 'kickstart.plugins.neo-tree',|require 'kickstart.plugins.neo-tree',|" "$NVIM_CONFIG_DIR/init.lua"

    # Enable TypeScript/JavaScript LSP
    sed -i "s|-- ts_ls = {},|ts_ls = {},|" "$NVIM_CONFIG_DIR/init.lua"
fi

echo "==> AI coding tools installation complete!"
