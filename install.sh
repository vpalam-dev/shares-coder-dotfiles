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
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
fi

# Ripgrep (used by LazyVim's Telescope live grep)
if command -v rg &> /dev/null; then
    echo "==> Ripgrep already installed, skipping"
else
    echo "==> Installing Ripgrep..."
    RG_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    curl -Lo ripgrep.tar.gz "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
    tar xf ripgrep.tar.gz --strip-components=1 "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl/rg"
    sudo install rg /usr/local/bin
    rm -f rg ripgrep.tar.gz
fi

# Zellij (terminal multiplexer)
if command -v zellij &> /dev/null; then
    echo "==> Zellij already installed, skipping"
else
    echo "==> Installing Zellij..."
    curl -fsSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C /tmp
    sudo install /tmp/zellij /usr/local/bin
    rm -f /tmp/zellij
fi

# Zellij dev layout
ZELLIJ_LAYOUT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zellij/layouts"
echo "==> Configuring Zellij dev layout..."
mkdir -p "$ZELLIJ_LAYOUT_DIR"
cat > "$ZELLIJ_LAYOUT_DIR/dev.kdl" << 'ZELLIJKDL'
layout {
    tab name="dev" focus=true {
        pane split_direction="vertical" {
            // Top row: nvim + claude
            pane split_direction="horizontal" {
                pane {
                    name "nvim"
                    size "65%"
                    command "nvim"
                    args "."
                    cwd "/workspaces/shares"
                }
                pane {
                    name "claude"
                    command "claude"
                    cwd "/workspaces/shares"
                }
            }

            // Bottom row: attach to already-running shpool server sessions
            pane size="30%" split_direction="horizontal" {
                pane {
                    name "server"
                    command "shpool"
                    args "attach" "server" "--force"
                    cwd "/workspaces/shares"
                }
                pane {
                    name "mock-server"
                    command "shpool"
                    args "attach" "mock-server" "--force"
                    cwd "/workspaces/shares"
                }
                pane {
                    name "tests-server"
                    command "shpool"
                    args "attach" "tests-server" "--force"
                    cwd "/workspaces/shares"
                }
            }
        }
    }

    tab name="shell" {
        pane {
            name "shell"
            cwd "/workspaces/shares"
        }
    }
}
ZELLIJKDL

# dev alias in bashrc
if ! grep -q 'alias dev=' "$HOME/.bashrc" 2>/dev/null; then
    echo "==> Adding dev alias to .bashrc..."
    echo 'alias dev="zellij --layout dev"' >> "$HOME/.bashrc"
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

# Neovim options (OSC52 clipboard for SSH/remote environments)
echo "==> Configuring Neovim options..."
cat > "$NVIM_CONFIG_DIR/lua/config/options.lua" << 'OPTLUA'
-- Use system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- OSC52 clipboard so copy/paste works over SSH / Coder
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = function() return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') } end,
    ["*"] = function() return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') } end,
  },
}
OPTLUA

# Neovim keymaps
echo "==> Configuring Neovim keymaps..."
cat > "$NVIM_CONFIG_DIR/lua/config/keymaps.lua" << 'KEYLUA'
-- Copy current buffer's full path to clipboard
vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })

-- Treesitter incremental selection via Flash (Ctrl+Space alternative)
vim.keymap.set({ "n", "o", "x" }, "<C-]>", function()
  require("flash").treesitter({
    actions = {
      ["<C-]>"] = "next",
      ["<BS>"] = "prev",
    },
  })
end, { desc = "Treesitter Incremental Selection" })
KEYLUA

# Treesitter parsers for TypeScript/JS
echo "==> Configuring Treesitter parsers..."
cat > "$NVIM_CONFIG_DIR/lua/plugins/treesitter.lua" << 'TSLUA'
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "typescript",
      "tsx",
      "javascript",
    },
  },
}
TSLUA

# Supermaven (LLM autocomplete, free tier)
echo "==> Configuring Supermaven for Neovim..."
cat > "$NVIM_CONFIG_DIR/lazyvim.json" << 'LAZYJSON'
{
  "extras": [
    "lazyvim.plugins.extras.ai.supermaven",
    "lazyvim.plugins.extras.lang.json",
    "lazyvim.plugins.extras.lang.markdown",
    "lazyvim.plugins.extras.lang.typescript",
    "lazyvim.plugins.extras.formatting.biome",
    "lazyvim.plugins.extras.linting.eslint"
  ],
  "install_version": 8,
  "news": {},
  "version": 8
}
LAZYJSON

cat > "$NVIM_CONFIG_DIR/lua/plugins/supermaven.lua" << 'SMLUA'
return {
  "supermaven-inc/supermaven-nvim",
  opts = {
    condition = function()
      local filename = vim.fn.expand("%:t")
      return filename:match("^%.env") ~= nil
    end,
  },
}
SMLUA

echo "==> AI coding tools installation complete!"
