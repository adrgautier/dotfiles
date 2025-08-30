# empty greetings
set fish_greeting

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/fnm"
set -gx PATH "$PNPM_HOME" $PATH

# pnpm
set -gx FNM_HOME "$HOME/.local/share/pnpm"
set -gx PATH "$FNM_HOME" $PATH

# fnm init
status is-interactive; and fnm env | source