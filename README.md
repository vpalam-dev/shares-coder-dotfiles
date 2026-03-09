# Coder Dotfiles

Install script for AI coding CLI tools and Neovim with [LazyVim](https://www.lazyvim.org/).

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
| `Space ff` | `Cmd+P` — find file by name |
| `Space sg` | `Cmd+Shift+F` — search text across files |
| `Space /` | `Cmd+F` — search in current buffer |
| `Space ,` | Switch between open buffers (tabs) |
| `Space fr` | Open recent files |
| `Space e` | Toggle file tree sidebar (like Explorer) |

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
| `gd` | Go to definition (`F12`) |
| `gr` | Find all references (`Shift+F12`) |
| `Space cr` | Rename symbol (`F2`) |
| `Space ca` | Code actions (Quick Fix) |
| `K` | Hover info |
| `Space xx` | Show diagnostics (Problems panel) |
| `[d` / `]d` | Jump to prev / next diagnostic |
| `Space cf` | Format file |

### Autocomplete

| Neovim | What it does |
|---|---|
| `Ctrl+n` / `Ctrl+p` | Next / previous suggestion |
| `Enter` | Accept completion |
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
| `Space bd` | Close buffer (close tab) |

### Tips

- Press `Space` and wait to see all available keybinds (which-key popup)
- `Space sk` searches all keymaps if you forget something
- `Space sh` searches the help docs
- Run `:Lazy` to manage plugins
- Run `:LazyExtras` to enable language support and other extras
- Run `:Mason` to manage language servers
