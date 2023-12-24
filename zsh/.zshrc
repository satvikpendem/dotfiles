if [[ "$(uname)" == "Darwin" ]]; then
    # Homebrew
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/opt/curl/bin:$PATH"

    # Ruby (for XCode)
    export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"

    # Postgres
    export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@16/lib/pkgconfig"

    # iTerm2 integration
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Rust
export PATH=$HOME/.cargo/bin:$PATH
export CARGO_TARGET_DIR=$HOME/.cargo/cache
# `RUSTFLAGS="-Ctarget-cpu=native" cargo build --release` makes sure that the
# binary is compiled with the CPU's native instructions. This is useful for
# speeding up the binary.
# We use RUSTFLAGS instead of `cargo build --release --target-cpu=native` because
# the latter works only for the top-level crate, and not for its dependencies, while
# the RUSTFLAGS works for all dependencies
export RUSTFLAGS="-Ctarget-cpu=native"

# Starship.rs
if [[ "$(uname)" == "Darwin" ]]; then
    export STARSHIP_CONFIG=~/dotfiles/starship/starship-macos.toml
else
    export STARSHIP_CONFIG=~/dotfiles/starship/starship-unix.toml
fi
eval "$(starship init zsh)"

# Haskell
[ -f "/home/satvik/.ghcup/env" ] && source "/home/satvik/.ghcup/env" # ghcup-env

# Python
export PATH=$HOME/.local/bin:$PATH

# WSL
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib/wsl/lib

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

# fnm
export PATH=$HOME/.fnm:$PATH
eval "$(fnm env --use-on-cd)"

# Deno
export DENO_INSTALL=$HOME/.deno
export PATH="$DENO_INSTALL/bin:$PATH"

# Flutter
export PATH=$HOME/flutter/bin:$PATH

# Default editor for git and others
export EDITOR=vim

# Aliases
alias vim="nvim"
alias ls="eza -la --git --icons -la"
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
alias tree="erd -y inverted -H -I"
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
    alias bug="brew update && brew upgrade && brew autoremove && brew cleanup --prune=all"
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
alias ga="git add"
alias gc="git commit"
alias gp="git push -u"
alias gap="git add . && git commit && git push"
alias gic="git add . && git commit -am 'Init commit' && git push -u"
ghi() {
    # If the gh command is not found, return an error
    if ! [ -x "$(command -v gh)" ]; then
        echo "gh command not found"
        # If on macOS, suggest to install gh using Homebrew
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "Install gh using Homebrew: brew install gh"
        elif [[ "$(uname)" == "Linux" ]]; then
            echo "Install gh using apt: https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt"
        fi
        return 1
    fi

    local REPO_NAME=""
    local REPO_VISIBILITY="--private"
    local REMOTE="origin"

    # Process the arguments
    # If the argument is --public, set the REPO_VISIBILITY variable to --public which will be used in the `gh repo create` command
    # This allows for usage like `ghi --public my-repo` or `ghi my-repo --public`
    for arg in "$@"; do
        if [ "$arg" = "--public" ]; then
            REPO_VISIBILITY="--public"
        elif [ -z "$REPO_NAME" ]; then
            REPO_NAME="$arg"
        else
            echo "Invalid argument: $arg"
            return 1
        fi
    done

    # Check if repository name is provided
    if [ -z "$REPO_NAME" ]; then
        echo "Repository name is required"
        return 1
    fi

    # If any subfolders have a `.git` directory, delete that `.git` directory
    find . -type d -name ".git" -exec rm -rf {} \;

    # Check if `.git` directory exists, if not, initialize git
    if [ ! -d ".git" ]; then
        git init
        echo "Initialized git"
    fi

    # Run the `gh repo create` command and store the output in a variable
    # This will also set the remote to the repository URL
    local GH_OUTPUT=$(gh repo create "$REPO_NAME" $REPO_VISIBILITY --source=. --remote=$REMOTE)
    echo "Created repository on GitHub: $GH_OUTPUT"

    # Add all files and commit
    git add .
    echo "Added all files"
    git commit -m "Init commit"
    echo "Committed"

    # Check for branches, either main or master
    local BRANCH=$(git branch -a | grep -o 'main\|master' | head -n 1)
    echo "Branch: $BRANCH"

    if [ -z "$BRANCH" ]; then
        echo "No branch found, using main"
        BRANCH="main"
        echo "Branch: $BRANCH"
    fi

    echo "Pushing to $BRANCH"
    git push --set-upstream $REMOTE $BRANCH
    echo "Completed successfully"
}

## Cargo
alias cb="cargo binstall --no-confirm"
alias ci="cargo install"

## Whisper
export PATH=$HOME/dotfiles/zsh/scripts/whisper:$PATH

## YouTube
export PATH=$HOME/dotfiles/zsh/scripts/yt-dlp:$PATH

yta() {
    yt "$@" -a
}

yts() {
    yt "$@" -s
}

ytas() {
    yt "$@" -a -s
}

## Miscellaneous
alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias vv="vim ~/.vimrc"

# zsh cd case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# # zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
# source $HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# # history-substring-search
# source $HOME/dotfiles/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# source $HOME/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
# HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=white,bold'
# HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
# HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

# Use bat with manpages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
