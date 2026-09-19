# Coder Dotfiles

Install script for AI coding agents, plus the tools for reviewing what they
changed and getting around a project, in Coder workspaces.

```bash
./install.sh
```

Everything is installed into `~/.local/bin`. The script adds one line to
`~/.bashrc`, `~/.zshrc` and `~/.profile` that sources
`~/.config/coder-dotfiles/shellrc.sh` (a copy of [`shellrc.sh`](shellrc.sh)),
which sets `PATH`, `$EDITOR` and the shell helpers below.

## What gets installed

| Tool | Command | Purpose |
| --- | --- | --- |
| Claude Code | `claude` | AI agent |
| Codex | `codex` | AI agent |
| Cursor CLI | `cursor-agent`, `agent` | AI agent |
| Unpeel | `unpeel` | Always-on terminal sessions for agents |
| lazygit | `lazygit`, `lg` | See what changed, stage, discard, commit |
| delta | `delta` | Syntax-highlighted diffs (git pager + lazygit) |
| Fresh | `fresh` | Non-modal editor with file tree, fuzzy open, grep, diff review |
| yazi | `yazi`, `y` | File manager with previews |
| fzf, fd, bat, ripgrep | `fzf`, `fd`, `bat`, `rg` | Fuzzy finder, find, cat, grep (power `ff` / `fs`) |

## Cheatsheet

### "What did the agent change?"

```bash
lg                     # lazygit: changed files on the left, diff on the right
git diff               # same thing as plain text, rendered by delta (n / N jump between files)
git diff main...       # everything this branch changed since it left main
```

### lazygit (`lg`)

| Key | Action |
| --- | --- |
| `←` `→` or `1`–`5` | Switch panel (Status, Files, Branches, Commits, Stash) |
| `↑` `↓` | Move in the list; the diff follows |
| `` ` `` | Toggle flat list / file tree |
| `Enter` | Open a file to view its hunks (then `Space` stages a hunk, `Esc` goes back) |
| `Space` | Stage / unstage file |
| `a` | Stage / unstage everything |
| `d` | Discard changes (asks first) |
| `e` | Open the file in Fresh |
| `c` / `P` / `p` | Commit / push / pull |
| `W` | Diff against another branch or commit, e.g. review a whole agent branch vs `main` |
| `+` / `_` | Enlarge / shrink the diff panel |
| `{` / `}` | Less / more context lines in the diff |
| `PgUp` `PgDn` | Scroll the diff |
| `/` | Filter the current list |
| `z` | Undo the last git action |
| `?` | All keybindings for the current panel |
| `q` | Quit |

### Fresh (`fresh`) – the editor

Works like a GUI editor: mouse, menus, `Ctrl+S`, `Ctrl+Z`, `Ctrl+C` / `Ctrl+V`.

```bash
fresh .                # open the project
fresh src/main.rs:42   # open a file at a line
```

| Key | Action |
| --- | --- |
| `Ctrl+P` | Quick open: files by name. Type `>` for commands, `#` for open buffers, `:` for a line number |
| `Ctrl+B` / `Ctrl+E` | Toggle / focus the file tree (shows git status; arrows + `Enter`) |
| `Alt+/` | Live grep across the project (`Alt+R` resumes the last search) |
| `Ctrl+F` / `F3` | Find in file / next match |
| `Ctrl+R` | Replace in file |
| `Ctrl+G` | Go to line |
| `F12` | Go to definition (needs the language server) |
| `Alt+←` / `Alt+→` | Jump back / forward |
| `Ctrl+PgUp` / `Ctrl+PgDn` | Previous / next tab |
| `Alt+W` | Close tab |
| `Alt+]` / `Alt+[` | Next / previous split |
| `` Alt+` `` | Terminal |
| `Ctrl+S` / `Ctrl+Q` | Save / quit |

Git review lives in the command palette (`Ctrl+P`, then `>`):

| Command | What it does |
| --- | --- |
| `Review Diff` | All staged, unstaged and untracked changes in one buffer. `n` / `p` jump between hunks; stage or discard from there |
| `Review Diff: Range (Commit or Branch)` | Review a whole branch, e.g. `main..HEAD` |
| `Git Log` | Commit list with a live diff preview |
| `Git Blame` | Blame for the current file |
| `Live Diff: Toggle` | Mark changed lines in the gutter while browsing |
| `Keybinding Editor` | See or change any key |

### Jumping around from the shell

| Command | Action |
| --- | --- |
| `ff [query]` | Fuzzy-find a file by name with a preview, `Enter` opens it in Fresh |
| `fs [query]` | Live-search file contents, `Enter` opens the match at its line |
| `y` | yazi; when you quit, the shell `cd`s to where you ended up |
| `Ctrl+T` | Paste a fuzzy-picked file path into the current command |
| `Alt+C` | Fuzzy `cd` into a subdirectory |
| `Ctrl+R` | Fuzzy search shell history |
| `bat file` | `cat` with syntax highlighting and line numbers |
| `rg pattern` / `fd name` | Fast grep / find that respect `.gitignore` |

### yazi (`y`)

Three columns: parent, current directory, preview of the selection.

| Key | Action |
| --- | --- |
| `↑` `↓` | Move |
| `→` / `Enter` | Enter directory / open file in Fresh |
| `←` | Parent directory |
| `z` | Jump to a file or directory with fzf |
| `s` / `S` | Search by name (fd) / by content (ripgrep) |
| `/` | Find in the current directory (`n` / `N` next / previous) |
| `.` | Toggle hidden files |
| `Space` | Select |
| `y` / `x` / `p` / `d` | Copy / cut / paste / trash |
| `a` / `r` | Create / rename |
| `F1` or `~` | Help |
| `q` | Quit |

## Files

- [`install.sh`](install.sh) – installs everything; safe to re-run, skips what is already present.
- [`shellrc.sh`](shellrc.sh) – `PATH`, `$EDITOR`, fzf key bindings and the `ff` / `fs` / `y` / `lg` helpers.
- [`lazygit.yml`](lazygit.yml) – copied to `~/.config/lazygit/config.yml` if none exists: delta for diffs, Fresh as the editor.
