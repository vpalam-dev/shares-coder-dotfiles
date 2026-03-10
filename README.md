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

### In-File Navigation

| Neovim | What it does |
|---|---|
| `s` + 2 chars + label | **Flash jump** — instantly jump anywhere visible on screen |
| `/` | Search in current file |
| `n` / `N` | Next / previous search match |
| `*` | Search for word under cursor |

### File Navigation

| Neovim | VS Code equivalent |
|---|---|
| `Space ff` | `Cmd+P` — find file by name |
| `Space sg` | `Cmd+Shift+F` — search text across files |
| `Space /` | `Cmd+F` — search in current buffer |
| `Space ,` | Switch between open buffers (tabs) |
| `Space fb` | Find open buffers |
| `Space fr` | Open recent files |
| `Space e` | Toggle file tree sidebar (like Explorer) |
| `H` / `L` | Previous / next buffer (like switching tabs) |

### Search Tips

`Space sg` uses ripgrep. You can pass flags after `--` in the search prompt:

| Search input | What it does |
|---|---|
| `foo -- -w` | Whole word match (e.g., `if` won't match `elif`) |
| `foo -- -i` | Case insensitive |
| `foo -- -w -i` | Whole word + case insensitive |

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
| `gcc` | Toggle comment line (`Cmd+/`) |
| `gc` (visual) | Toggle comment block (`Cmd+Shift+/`) |
| `Alt+j` / `Alt+k` | Move line down / up |
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

### Search & Replace

| Neovim | VS Code equivalent |
|---|---|
| `/` | `Cmd+F` — search in file |
| `:%s/old/new/g` | `Cmd+H` — find & replace in file |
| `Space sr` | `Cmd+Shift+H` — search & replace across files |

### Windows and Buffers

| Neovim | VS Code equivalent |
|---|---|
| `:w` | Save (`Cmd+S`) |
| `:q` | Close window |
| `:wq` | Save and close |
| `:e {file}` | Open a file |
| `Space -` / `Space \|` | Split horizontal / vertical |
| `Ctrl+h/j/k/l` | Move between split panes |
| `Space bd` | Close buffer (close tab) |

### Terminal & Git

| Neovim | VS Code equivalent |
|---|---|
| `Ctrl+/` | Toggle terminal (`Ctrl+\``) |
| `Space gg` | Open Lazygit (full git UI) |

### Theme

| Neovim | What it does |
|---|---|
| `Space uC` | Open colorscheme picker |
| `:set bg=light` | Switch to light theme |
| `:set bg=dark` | Switch to dark theme |

### Sidebar & Buffer Focus

`Space e` **toggles** the file tree — if it's open, it closes it. To move focus without closing:

| Neovim | What it does |
|---|---|
| `Ctrl+h` | Focus left pane (sidebar) |
| `Ctrl+l` | Focus right pane (buffer) |
| `H` / `L` | Previous / next buffer (tab) |
| `Space ,` | Pick from open buffers |
| `Space bd` | Close current buffer |

## Zellij

The `dev` alias launches zellij with the dev layout (nvim + claude + shpool sessions).

### Pane Navigation

| Zellij | What it does |
|---|---|
| `Ctrl+p` then `h/j/k/l` or arrows | Move focus between panes |
| `Ctrl+p` then `n` | New pane |
| `Ctrl+p` then `x` | Close current pane |
| `Ctrl+p` then `f` | Toggle fullscreen for current pane |
| `Ctrl+p` then `e` | Toggle floating pane |
| `Ctrl+n` then arrows | Resize current pane |
| `Ctrl+t` then `h/l` or arrows | Switch between tabs |
| `Ctrl+t` then `n` | New tab |

### Tips

- Press `Space` and wait to see all available keybinds (which-key popup)
- `Space sk` searches all keymaps if you forget something
- `Space sh` searches the help docs
- Run `:Lazy` to manage plugins
- Run `:LazyExtras` to enable language support and other extras
- Run `:Mason` to manage language servers
