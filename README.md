# Coder Dotfiles

Install script for AI coding CLI tools and Neovim with [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

```bash
./install.sh
```

## Neovim for VS Code Users

### Modes

Neovim is modal — you're always in one of these modes:

| Mode | How to enter | Purpose |
|---|---|---|
| Normal | `Esc` | Navigate, delete, copy, paste |
| Insert | `i` | Type text (like VS Code default) |
| Visual | `v` | Select text |
| Command | `:` | Run commands (like the command palette) |

### Basic Navigation

| Neovim | VS Code equivalent |
|---|---|
| `h` `j` `k` `l` | Arrow keys (left, down, up, right) |
| `gg` / `G` | Go to top / bottom of file |
| `Ctrl+d` / `Ctrl+u` | Page down / up |
| `w` / `b` | Move forward / back by word |
| `0` / `$` | Go to start / end of line |
| `:{number}` | Go to line number |

### File Navigation

| Neovim | VS Code equivalent |
|---|---|
| `Space sf` | `Cmd+P` — find file by name |
| `Space sg` | `Cmd+Shift+F` — search text across files |
| `Space /` | `Cmd+F` — search in current file |
| `Space Space` | Switch between open buffers (tabs) |
| `Space s.` | Open recent files |
| `\` | Toggle file tree sidebar (like Explorer) |

### Editing

| Neovim | VS Code equivalent |
|---|---|
| `i` | Start typing at cursor |
| `a` | Start typing after cursor |
| `o` / `O` | New line below / above |
| `dd` | Delete (cut) line |
| `yy` | Copy line |
| `p` | Paste |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `ciw` | Select and replace current word |
| `ci"` | Select and replace inside quotes |
| `.` | Repeat last action |

### Code Intelligence (LSP)

| Neovim | VS Code equivalent |
|---|---|
| `grd` | Go to definition (`F12`) |
| `grr` | Find all references (`Shift+F12`) |
| `grn` | Rename symbol (`F2`) |
| `gra` | Code actions (Quick Fix) |
| `K` | Hover info |
| `Space q` | Show diagnostics (Problems panel) |
| `[d` / `]d` | Jump to prev / next error |
| `Space f` | Format file |

### Autocomplete

| Neovim | What it does |
|---|---|
| `Ctrl+n` / `Ctrl+p` | Next / previous suggestion |
| `Ctrl+y` | Accept completion |
| `Ctrl+e` | Dismiss menu |
| `Ctrl+Space` | Trigger completion manually |

### Windows and Buffers

| Neovim | VS Code equivalent |
|---|---|
| `:w` | Save (`Cmd+S`) |
| `:q` | Close window |
| `:wq` | Save and close |
| `:e {file}` | Open a file |
| `Ctrl+h/j/k/l` | Move between split panes |

### Tips

- Press `Space` and wait to see all available keybinds (which-key popup)
- `Space sk` searches all keymaps if you forget something
- `Space sh` searches the help docs
- Run `:Tutor` for an interactive tutorial
- Run `:Lazy` to manage plugins
- Run `:Mason` to manage language servers
