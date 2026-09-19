# Sourced from ~/.bashrc, ~/.zshrc and ~/.profile (see install.sh).
# Keep this POSIX-compatible: ~/.profile may be read by sh.

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR=fresh
export VISUAL=fresh
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

# ff [query]: fuzzy-find a file by name and open it.
ff() {
    local file
    file="$(fzf --query "$*" --preview 'bat --color=always --style=numbers {}')" || return
    "$EDITOR" "$file"
}

# fs [query]: live-search file contents and open the match at its line.
fs() {
    local rg_cmd sel file line
    rg_cmd='rg --column --line-number --no-heading --color=always --smart-case --hidden --glob !.git'
    sel="$(fzf --ansi --disabled --query "$*" \
        --bind "start:reload:$rg_cmd {q} || true" \
        --bind "change:reload:$rg_cmd {q} || true" \
        --delimiter : \
        --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
        --preview-window '+{2}/2')" || return
    file="${sel%%:*}"
    line="${sel#*:}"
    line="${line%%:*}"
    fresh "$file:$line"
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
