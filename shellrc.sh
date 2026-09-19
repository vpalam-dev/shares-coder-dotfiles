# Sourced from ~/.bashrc, ~/.zshrc and ~/.profile (see install.sh).
# Keep this POSIX-compatible: ~/.profile may be read by sh.

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR=micro
export VISUAL=micro
export BAT_THEME=ansi

# fzf lists files with fd: respects .gitignore, includes dotfiles.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# The rest only matters in interactive shells.
case $- in
    *i*) ;;
    *) return 0 ;;
esac

# Ctrl-T (paste file path), Ctrl-R (history), Alt-C (cd into directory).
if command -v fzf > /dev/null 2>&1; then
    if [ -n "${BASH_VERSION:-}" ]; then
        eval "$(fzf --bash)"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(fzf --zsh)"
    fi
fi

alias lg=lazygit

# ff [query]: fuzzy-find files by name and open them (Tab selects several,
# each opens in its own micro tab).
ff() {
    local files file
    files="$(ff-pick "$@")" || return
    # One path per line, so names with spaces survive.
    set --
    while IFS= read -r file; do
        set -- "$@" "$file"
    done << FILES
$files
FILES
    micro "$@"
}

# fs [query]: live-search file contents and open the match at its line.
fs() {
    local sel
    sel="$(fs-pick "$@")" || return
    micro "+${sel##*:}" "${sel%:*}"
}

# y: yazi, but the shell follows you to the directory you quit in.
y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    cwd="$(cat "$tmp")"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd "$cwd"
    rm -f "$tmp"
}
