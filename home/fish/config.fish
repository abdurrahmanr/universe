starship init fish | source
fzf --fish | source
zoxide init fish | source

alias v="nvim"
alias cd="z"
set fish_greeting

set -gx PATH $HOME/.cargo/bin $PATH

set -gx QT_QPA_PLATFORMTHEME qt6ct
