# Rust
export PATH=/home/satvik/.cargo/bin:$PATH
export CARGO_TARGET_DIR=$HOME/.cargo/cache

# Nim
export PATH=/home/satvik/.nimble/bin:$PATH

# Starship.rs
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

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

# zsh cd case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
