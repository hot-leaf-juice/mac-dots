HISTFILE=$HOME/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

setopt HIST_IGNORE_ALL_DUPS
setopt INTERACTIVECOMMENTS
setopt PROMPT_SUBST
setopt SHARE_HISTORY
unsetopt nomatch

autoload -Uz compinit promptinit
compinit
promptinit

autoload -U colors
colors

autoload -U zmv

o_widget() {
  local dir
  dir=$(fd -t d | fzf) &&
  cd "$dir"
  zle reset-prompt
}

zle -N o_widget
bindkey '^o' o_widget

alias b='git checkout $(git branch | awk '\''!/\*/'\''| fzf)'
alias diff='colordiff -u'
alias dropbox='dropbox-cli'
alias ff='firefox-developer'
alias ghci='stack exec -- ghci'
alias git='hub'
alias gup='gup -t $GUP_TOKEN'
alias kc='kubectl -n chatkit'
alias kcd='kc --context deneb'
alias kci='kc --context integration1 -n $(kc --context integration1 get ns | awk "/chatkit/ { print \$1 }")'
alias kcm='kc --context minikube -n chatkit-acceptance'
alias kcp='kc --context us1'
alias kcs='kc --context us1-staging'
alias l='cd $(cat $HOME/.wd) && pwd'
alias ls='ls --color=auto'
alias mix='pulsemixer'
alias mmv='noglob zmv -W'
alias open='xdg-open'
alias py='python'
alias rc='cat $(fd -tf)'
alias s='pwd > $HOME/.wd'
alias tree='tree -C'
alias vi='nvim'
alias vim='nvim'
alias xvi='xargs nvim'

source $HOME/.config/git-prompt.sh

RPROMPT='%F{red}$(__git_ps1 "%s")%f'

# enable full screen editing
autoload edit-command-line
zle -N edit-command-line

# zsh vi bindings config
bindkey -v
bindkey -M vicmd v edit-command-line

function n {
  if [[ $1 == pull ]]; then
    cd $HOME/notes
    git pull
  elif [[ $1 == push ]]; then
    cd $HOME/notes
    git add .
    git commit -m "$(date)"
    git push
  elif [[ $1 == '' ]]; then
    cd $HOME/notes
  fi
}

function zle-line-init zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    separator="!"
  elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP = '' ]]; then
    separator="$"
  fi
  PROMPT=$'\n'"%F{red}%1/ $separator %f"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

source $HOME/bin/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export FZF_DEFAULT_COMMAND='fd -t f'
export FZF_DEFAULT_OPTS='--reverse --height 16'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=green'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red'
export HISTORY_SUBSTRING_SEARCH_FUZZY=1
export KEYTIMEOUT=1
export KUBECONFIG="$HOME/.kube/config"
export VISUAL='nvim'
export EDITOR="$VISUAL"
export GOPATH="$HOME/code/go"
export PASSWORD_STORE_DIR="$HOME/.password-store"
export VAULT_ADDR='https://vault.pusherplatform.io:8200'
export PATH="$HOME/.cargo/bin:$GOPATH/bin:$GEM_HOME/bin:$HOME/.local/bin:$HOME/bin:$HOME/.yarn/bin:$PATH"
source "$HOME/.export-secrets"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  startx
fi

tabs -4
