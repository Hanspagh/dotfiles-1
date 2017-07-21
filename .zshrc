PROMPT='[%F{1}%n%f@%F{5}%m%f %F{3}%1~%f]%F{4}%#%f '
#
# Set vim  as editor.
export EDITOR="vim"

# Source colors generated by wal.
source "${HOME}/.cache/wal/colors.sh"

# Don't log duplicate commands.
export HISTCONTROL=ignoredups

# ALIASES

alias ls="ls-i --color=auto"
alias dir="dir-i --color=auto"
alias vdir="vdir-i --color=auto"
alias pacyyu="sudo pacman -Syyu"
alias ls="ls --color"
alias shutdown="systemctl poweroff"
alias pacyy="sudo pacman -Syy"
alias pacyu="sudo pacman -Syu"
alias vim="vim"

# Import colorscheme from 'wal'
[[ -z "$VTE_VERSION" ]] && (wal -r &)

autoload -Uz promptinit 
promptinit
