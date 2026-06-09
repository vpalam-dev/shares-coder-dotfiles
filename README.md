# Coder Dotfiles

Install script for coding CLI tools and terminal workflow helpers used in Coder workspaces.

```bash
./install.sh
```

## Installed Tools

- Codex
- Opencode

## Git Push Hooks

The install script adds a shell wrapper for `git` to both `~/.bashrc` and `~/.zshrc`.
When you run `git push` interactively, the wrapper runs:

```bash
git push --no-verify
```

That skips pre-push hooks in Coder without changing repository hook configuration.
Other `git` commands are passed through unchanged.
