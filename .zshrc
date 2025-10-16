if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    fastfetch --config examples/13
 fi

eval "$(/usr/bin/oh-my-posh init zsh --config ~/.config/omp/config.omp.json)"

export EDITOR="nvim"
export GTK_THEME="Tokyo-Dark-Storm"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# Add in zsh plugins
zinit ice wait="2" lucid
zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait="2" lucid
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit ice wait="2" lucid
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e # emacs Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# bindkey '^y' yy

# History
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt auto_cd

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias xcopy="xsel --input --clipboard"
alias xpaste="xsel --output --clipboard"
alias c='clear'
alias cls="clear"
alias yeet="paru -Rcs"
alias cp-node="rsync -av --exclude=node_modules --exclude=target --exclude=.next --exclude=.svelte-kit --exclude=mssql"
alias dev="bun dev"
alias install="bun install"
alias open="xdg-open"

cdm() {
  mkdir $@ && cd $@
}

up() {
    docker compose up -d
    if [ -f run.sh ]; then
        ./run.sh >> /dev/null
    fi
}


alias down="docker compose down"

# export PATH="/opt/homebrew/bin:$PATH"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Change opener to handlr
export PATH="$HOME/.local/bin:$PATH"

## bun completions
# [ -s "/home/motb/.bun/_bun" ] && source "/home/motb/.bun/_bun"

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"
eval $(thefuck --alias)

# start in tmux
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   tmux attach || exec tmux;
# fi

# yazi shell wrapper to change cwd when exiting yazi

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

    if [ -d "$1" ]; then
      yazi "$1" --cwd-file="$tmp"
    else
      yazi "$(zoxide query $@)" --cwd-file="$tmp"
    fi

    if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd";
    fi

    rm -f -- "$tmp"
}

function y() {
  if [ "$@" != "" ]; then
    if [ -d "$@" ]; then
      yazi "$@"
    else
      yazi "$(zoxide query $@)"
    fi
  else
    yazi
  fi
    return $?
}



export PATH=$PATH:/home/motb/.spicetify

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/motb/.dart-cli-completion/zsh-config.zsh ]] && . /home/motb/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

