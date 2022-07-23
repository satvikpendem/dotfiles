# Rust
export PATH=/home/satvik/.cargo/bin:$PATH
export CARGO_TARGET_DIR=$HOME/.cargo/cache

# Starship.rs
export STARSHIP_CONFIG=~/dotfiles/starship-unix.toml
eval "$(starship init zsh)"

# Bind ctrl+key actions
### ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
# urxvt
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word

### ctrl+delete
bindkey "\e[3;5~" kill-word
# urxvt
bindkey "\e[3^" kill-word

### ctrl+backspace
bindkey '^H' backward-kill-word

### ctrl+shift+delete
bindkey "\e[3;6~" kill-line
# urxvt
bindkey "\e[3@" kill-line

# Save history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY_TIME
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Zoxide
eval "$(zoxide init zsh)"

# Nim
export PATH=/home/satvik/.nimble/bin:$PATH

# fnm
export PATH=/home/satvik/.fnm:$PATH
eval "`fnm env`"

# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# bun completions
[ -s "/home/satvik/.bun/_bun" ] && source "/home/satvik/.bun/_bun"

# Bun
export BUN_INSTALL="/home/satvik/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Default editor for git and others
export EDITOR=vim

# Aliases
alias vim="nvim"
alias ls="exa -la --git --icons"
alias l="ls"
alias cat="batcat"
alias fd="fdfind"
alias tree="exa --tree"
alias md="mkdir -p"
alias tl="tldr"
alias gc="git add . && git commit && git push"
alias gs="git status"
alias f="sk --preview 'bat --color=always --style numbers,changes {}'"
alias gap="git add . && git commit && git push"

## Apt
alias apt="sudo apt"
alias au="apt update -y"
alias ai="au && apt install -y"
alias aug="au && apt upgrade -y" 
alias ar="apt remove -y"
alias ac="apt autoclean -y"
alias aar="apt autoremove -y"

## Cargo
alias cb="cargo binstall --no-confirm"
alias ci="cargo install"

alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias vv="vim ~/.vimrc"

# zsh cd case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
