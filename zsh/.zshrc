if [[ "$(uname)" == "Darwin" ]]; then
    # Homebrew
    export PATH="/opt/homebrew/opt/curl/bin:$PATH"
fi

# Rust
export PATH=$HOME/.cargo/bin:$PATH
export CARGO_TARGET_DIR=$HOME/.cargo/cache

# Starship.rs
export STARSHIP_CONFIG=~/dotfiles/starship/starship-unix.toml
eval "$(starship init zsh)"

# Bind ctrl+key actions
### ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

### ctrl+delete
bindkey "\e[3;5~" kill-word

### ctrl+backspace
bindkey '^H' backward-kill-word

### ctrl+shift+delete
bindkey "\e[3;6~" kill-line

# Save history
setopt histignorealldups sharehistory extendedhistory
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY_TIME
export HISTTIMEFORMAT="[%F %T] "

# Zoxide
eval "$(zoxide init zsh)"

# Nim
export PATH=$HOME/.nimble/bin:$PATH

# fnm
export PATH=$HOME/.fnm:$PATH
eval "$(fnm env --use-on-cd)"

# Deno
export DENO_INSTALL=$HOME/.deno
export PATH="$DENO_INSTALL/bin:$PATH"

# Python (pyenv)
export PYENV_ROOT=$HOME/.pyenv
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Default editor for git and others
export EDITOR=vim

# Aliases
alias vim="nvim"
alias ls="exa -la --git --icons -la"
alias l="ls"
alias rm="rm -rf"
if [[ "$(uname)" == "Linux" ]]; then
  # If we find the commands below, that means they were installed
  # via `cargo` and not `apt`
  if ! [ -x "$(command -v bat)" ]; then
    alias cat="batcat"
  else
    alias cat="bat"
  fi
  if ! [ -x "$(command -v fd)" ]; then
    alias fd="fdfind"
  fi
elif [[ "$(uname)" == "Darwin" ]]; then
    alias cat="bat"
fi
alias tree="exa --tree"
alias md="mkdir -p"
alias tl="tldr"
alias f="sk --preview 'bat --color=always --style numbers,changes {}'"
alias ff='cd $(fd -H --type d | sk)' # Use fzf/skim to fuzzy search cd into directories

if [[ "$(uname)" == "Linux" ]]; then
    ## Apt
    alias apt="sudo apt"
    alias au="apt update -y"
    alias ai="au && apt install -y"
    alias aug="au && apt upgrade -y"
    alias ar="apt remove -y"
    alias ac="apt autoclean -y"
    alias aar="apt autoremove -y"
elif [[ "$(uname)" == "Darwin" ]]; then
    alias bi="brew install"
    alias bu="brew uninstall"
    alias bug="brew update && brew upgrade"
    alias bs="brew search"
    alias bt="brew tap"
    alias bta="brew tap --list"
    alias btl="brew untap"
fi

## Git
alias gi="git init"
alias grao="git remote add origin"
alias gs="git status"
alias gd="git diff"
alias gap="git add . && git commit && git push"
alias gic="git add . && git commit -am 'Init commit' && git push"

## Cargo
alias cb="cargo binstall --no-confirm"
alias ci="cargo install"

## Miscellaneous
alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias vv="vim ~/.vimrc"

# zsh cd case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
source $HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# history-substring-search
source $HOME/dotfiles/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

# Use bat with manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
