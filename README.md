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
| lazygit | `lazygit`, `lg` | See what changed, stage, discard, commit |
| delta | `delta` | Syntax-highlighted diffs (git pager + lazygit) |
| micro | `micro` | Small non-modal editor: tabs, splits, mouse, normal shortcuts |
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
| `e` | Open the file in micro |
| `c` / `P` / `p` | Commit / push / pull |
| `W` | Diff against another branch or commit, e.g. review a whole agent branch vs `main` |
| `+` / `_` | Enlarge / shrink the diff panel |
| `{` / `}` | Less / more context lines in the diff |
| `PgUp` `PgDn` | Scroll the diff |
| `/` | Filter the current list |
| `z` | Undo the last git action |
| `?` | All keybindings for the current panel |
| `q` | Quit |

### micro (`micro`) – the editor

Works like a GUI editor: mouse, `Ctrl+S`, `Ctrl+Z`, `Ctrl+C` / `Ctrl+V`, `Ctrl+Q`.
Some terminals send Option as a typed character (`˚`, `≈`), so micro's
`Alt+…` defaults don't work there; the keys below avoid Alt.

```bash
micro a.ts b.ts c.ts   # several files at once, one tab each
micro src/main.ts:42   # open at a line (also: micro +42 src/main.ts)
```

Working with several files:

| Key | Action |
| --- | --- |
| `Ctrl+P` | Fuzzy-pick files by name and open each in a new tab (`Tab` marks several, `Enter` opens) |
| `F7` | Live-search file contents, open the match in a new tab at its line |
| `F5` / `F6` | Previous / next tab (or click the tab bar) |
| `Ctrl+T` | New empty tab |
| `Ctrl+O` | Open a file in the current tab (path completion with `Tab`) |
| `Ctrl+Q` | Close the current tab / split; quits when it was the last one |
| `Ctrl+E` then `vsplit file` / `hsplit file` | Open a file side by side / stacked |
| `Ctrl+W` | Jump to the next split |
| `Ctrl+E` then `tab file` | Open a file in a new tab by path |

Editing:

| Key | Action |
| --- | --- |
| `Ctrl+S` | Save |
| `Ctrl+F` / `Ctrl+N` | Find / next match (`F3` also finds) |
| `Ctrl+E` then `replace foo bar` | Replace (asks per match; add `-a` for all) |
| `Ctrl+L` | Go to line |
| `Ctrl+D` / `Ctrl+K` | Duplicate line / cut line |
| `Ctrl+Z` / `Ctrl+Y` | Undo / redo |
| `Ctrl+E` | Command prompt (`ff`, `fs`, `set`, `help` …) |
| `Ctrl+G` | Help, including all default keys |

### Jumping around from the shell

| Command | Action |
| --- | --- |
| `ff [query]` | Fuzzy-find files by name with a preview; `Tab` marks several, `Enter` opens them as micro tabs |
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
| `→` / `Enter` | Enter directory / open file in micro |
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
- [`micro/`](micro) – copied to `~/.config/micro/` (existing files are kept): Alt-free keys, the `Ctrl+P` / `F7` pickers, clipboard over SSH.
- [`bin/`](bin) – `ff-pick` / `fs-pick`, the fzf pickers behind `ff`, `fs` and micro's `Ctrl+P` / `F7`.
- [`lazygit.yml`](lazygit.yml) – copied to `~/.config/lazygit/config.yml` if none exists: delta for diffs, micro as the editor.
