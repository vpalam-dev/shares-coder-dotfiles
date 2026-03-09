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

    # Add biome, eslint_d, and oxlint to Mason's ensure_installed
    sed -i "s|-- You can add other tools here that you want Mason to install|-- You can add other tools here that you want Mason to install\n        'biome',\n        'eslint_d',\n        'oxlint',|" "$NVIM_CONFIG_DIR/init.lua"

    # Configure conform.nvim formatters for JS/TS/JSON/CSS:
    #   - biome-check: runs biome format + lint fixes + import sorting
    #   - eslint_d: runs eslint --fix
    #   - oxlint: runs oxlint fixes
    sed -i "s|lua = { 'stylua' },|lua = { 'stylua' },\n        javascript = { 'biome-check', 'eslint_d', 'oxlint' },\n        typescript = { 'biome-check', 'eslint_d', 'oxlint' },\n        javascriptreact = { 'biome-check', 'eslint_d', 'oxlint' },\n        typescriptreact = { 'biome-check', 'eslint_d', 'oxlint' },\n        json = { 'biome-check' },\n        jsonc = { 'biome-check' },\n        css = { 'biome-check' },|" "$NVIM_CONFIG_DIR/init.lua"

    # Enable custom plugins import
    sed -i "s|-- { import = 'custom.plugins' },|{ import = 'custom.plugins' },|" "$NVIM_CONFIG_DIR/init.lua"

    # Add refactoring.nvim plugin
    cat > "$NVIM_CONFIG_DIR/lua/custom/plugins/init.lua" << 'REFACTOR_EOF'
---@module 'lazy'
---@type LazySpec
return {
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<leader>re', function() require('refactoring').refactor 'Extract Function' end, mode = 'x', desc = '[R]efactor [E]xtract function' },
      { '<leader>rv', function() require('refactoring').refactor 'Extract Variable' end, mode = 'x', desc = '[R]efactor extract [V]ariable' },
      { '<leader>ri', function() require('refactoring').refactor 'Inline Variable' end, mode = { 'n', 'x' }, desc = '[R]efactor [I]nline variable' },
      { '<leader>rf', function() require('refactoring').refactor 'Extract Block To File' end, desc = '[R]efactor extract block to [F]ile' },
      {
        '<leader>rr',
        function() require('refactoring').select_refactor() end,
        mode = { 'n', 'x' },
        desc = '[R]efactor select [R]efactoring',
      },
    },
    opts = {},
  },
}
REFACTOR_EOF
fi

echo "==> AI coding tools installation complete!"
