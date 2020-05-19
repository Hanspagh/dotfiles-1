# Set up completion
autoload -Uz compinit promptinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
promptinit
_comp_options+=(globdots) # Include hidden files.

# store history in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.cache/zsh/history"

# Enable desired plugins with oh my zsh
plugins=(git)
PROMPT='[%F{1}%n%f@%F{5}%m%f%F{3}%f]%F{6}~%f '

# Setup vi mode
bindkey -v

# Change cursor with support for inside/outside tmux
function _set_cursor() {
    if [[ $TMUX = '' ]]; then
      echo -ne $1
    else
      echo -ne "\ePtmux;\e\e$1\e\\"
    fi
}

function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      _set_block_cursor
  else
      _set_beam_cursor
  fi
}
zle -N zle-keymap-select
# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor) #
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey '^R' history-incremental-search-backward

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Source colors generated by wal.
source "${HOME}/.cache/wal/colors.sh"

# Source aliases
source "${HOME}/.config/zsh/aliasrc"

# Source functions
source "${HOME}/.config/zsh/functionrc"

# Source completion for tmuxinator
source "${HOME}/.config/tmuxinator/tmuxinator.zsh"

# Import colorscheme from 'wal'
(cat "$HOME/.cache/wal/sequences" &)

# If folder fzf is present with pacman, source binds and completion
if [ -e /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

# Use ag for fzf
# Uses same command for all binds - could make this for ALT_C
# Utility function to determine whether command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}
if _has fzf && _has rg; then
    export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="cd ~/; rg --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"

    # https://adamheins.com/blog/ctrl-p-in-the-terminal-with-fzf
    # This is the same functionality as fzf's ctrl-t, except that the file or
    # directory selected is now automatically cd'ed or opened, respectively.
    fzf-open-file-or-dir() {
      local cmd="command find -L . \
        \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
        -o -type f -print \
        -o -type d -print \
        -o -type l -print 2> /dev/null | sed 1d | cut -b3-"
      local out=$(eval $cmd | fzf-tmux --exit-0)

      if [ -f "$out" ]; then
        $EDITOR "$out" < /dev/tty
      elif [ -d "$out" ]; then
        cd "$out"
        zle reset-prompt
      fi
    }
    zle     -N   fzf-open-file-or-dir
    bindkey '^P' fzf-open-file-or-dir
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ecly/.local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/home/ecly/.local/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ecly/.local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/ecly/.local/share/google-cloud-sdk/completion.zsh.inc'; fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://stackoverflow.com/a/18915067/4000764
SSH_ENV="$HOME/.ssh/environment"
mkdir -p "$HOME/.ssh/"
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi