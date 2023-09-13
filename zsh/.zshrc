if [[ "$(uname)" == "Darwin" ]]; then
    # Homebrew
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/opt/curl/bin:$PATH"
    
    # Ruby (for XCode)
    export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"
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
alias ga="git add"
alias gc="git commit"
alias gp="git push -u"
alias gap="git add . && git commit && git push"
alias gic="git add . && git commit -am 'Init commit' && git push -u"
ghi() {
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

    # Check if `.git` directory exists, if not, initialize git
    if [ ! -d ".git" ]; then
        git init
        echo "Initialized git"
    fi

    # Run the gh repo create command and store the output in a variable
    local GH_OUTPUT=$(gh repo create "$REPO_NAME" $REPO_VISIBILITY --source=. --remote=$REMOTE)
    echo "Created repository on GitHub:"
    echo "$GH_OUTPUT"

    # Use grep and awk to parse the git repository URL from the output
    local REPO=$(echo "$GH_OUTPUT" | grep -o 'git@github.com:[^ ]*' | awk '{print $1}')
    echo "Repository URL: $REPO"

    # Add the remote origin
    git remote add origin "$REPO"
    echo "Added remote origin"

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

## mpv
yt() {
    local url=""
    local subtitles=false
    local audio=false
    local output="%(title)s.%(ext)s"
    local format
    local extract_audio=""
    local merge_output_format=""

    for arg in "$@"; do
        case "$arg" in
            -s)
                subtitles=true
                ;;
            -a)
                audio=true
                ;;
            *)
                if [[ "$arg" =~ ^https?:// ]]; then
                    url="$arg"
                else
                    echo "Invalid argument: $arg"
                    return 1
                fi
                ;;
        esac
    done

    local output="%(title)s.%(ext)s"
    if [[ "$url" =~ "playlist" ]]; then
        output="%(playlist)s/%(playlist_index)04d - %(title)s.%(ext)s"
    fi

    if [ "$audio" = "true" ]; then
        format="bestaudio[acodec^=opus]/bestaudio/best"
        output_format="mp3"
        extract_audio="--extract-audio"
    else
        format="(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp9.2][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=4320][fps>30]/bestvideo[vcodec^=av01][height>=4320]/bestvideo[vcodec^=vp9.2][height>=4320]/bestvideo[vcodec^=vp9][height>=4320]/bestvideo[vcodec^=avc1][height>=4320]/bestvideo[height>=4320]/bestvideo[vcodec^=av01][height>=2880][fps>30]/bestvideo[vcodec^=vp9.2][height>=2880][fps>30]/bestvideo[vcodec^=vp9][height>=2880][fps>30]/bestvideo[vcodec^=avc1][height>=2880][fps>30]/bestvideo[height>=2880][fps>30]/bestvideo[vcodec^=av01][height>=2880]/bestvideo[vcodec^=vp9.2][height>=2880]/bestvideo[vcodec^=vp9][height>=2880]/bestvideo[vcodec^=avc1][height>=2880]/bestvideo[height>=2880]/bestvideo[vcodec^=av01][height>=2160][fps>30]/bestvideo[vcodec^=vp9.2][height>=2160][fps>30]/bestvideo[vcodec^=vp9][height>=2160][fps>30]/bestvideo[vcodec^=avc1][height>=2160][fps>30]/bestvideo[height>=2160][fps>30]/bestvideo[vcodec^=av01][height>=2160]/bestvideo[vcodec^=vp9.2][height>=2160]/bestvideo[vcodec^=vp9][height>=2160]/bestvideo[vcodec^=avc1][height>=2160]/bestvideo[height>=2160]/bestvideo[vcodec^=av01][height>=1440][fps>30]/bestvideo[vcodec^=vp9.2][height>=1440][fps>30]/bestvideo[vcodec^=vp9][height>=1440][fps>30]/bestvideo[vcodec^=avc1][height>=1440][fps>30]/bestvideo[height>=1440][fps>30]/bestvideo[vcodec^=av01][height>=1440]/bestvideo[vcodec^=vp9.2][height>=1440]/bestvideo[vcodec^=vp9][height>=1440]/bestvideo[vcodec^=avc1][height>=1440]/bestvideo[height>=1440]/bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec^=vp9.2][height>=1080][fps>30]/bestvideo[vcodec^=vp9][height>=1080][fps>30]/bestvideo[vcodec^=avc1][height>=1080][fps>30]/bestvideo[height>=1080][fps>30]/bestvideo[vcodec^=av01][height>=1080]/bestvideo[vcodec^=vp9.2][height>=1080]/bestvideo[vcodec^=vp9][height>=1080]/bestvideo[vcodec^=avc1][height>=1080]/bestvideo[height>=1080]/bestvideo[vcodec^=av01][height>=720][fps>30]/bestvideo[vcodec^=vp9.2][height>=720][fps>30]/bestvideo[vcodec^=vp9][height>=720][fps>30]/bestvideo[vcodec^=avc1][height>=720][fps>30]/bestvideo[height>=720][fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec^=vp9.2][height>=720]/bestvideo[vcodec^=vp9][height>=720]/bestvideo[vcodec^=avc1][height>=720]/bestvideo[height>=720]/bestvideo[vcodec^=av01][height>=480][fps>30]/bestvideo[vcodec^=vp9.2][height>=480][fps>30]/bestvideo[vcodec^=vp9][height>=480][fps>30]/bestvideo[vcodec^=avc1][height>=480][fps>30]/bestvideo[height>=480][fps>30]/bestvideo[vcodec^=av01][height>=480]/bestvideo[vcodec^=vp9.2][height>=480]/bestvideo[vcodec^=vp9][height>=480]/bestvideo[vcodec^=avc1][height>=480]/bestvideo[height>=480]/bestvideo[vcodec^=av01][height>=360][fps>30]/bestvideo[vcodec^=vp9.2][height>=360][fps>30]/bestvideo[vcodec^=vp9][height>=360][fps>30]/bestvideo[vcodec^=avc1][height>=360][fps>30]/bestvideo[height>=360][fps>30]/bestvideo[vcodec^=av01][height>=360]/bestvideo[vcodec^=vp9.2][height>=360]/bestvideo[vcodec^=vp9][height>=360]/bestvideo[vcodec^=avc1][height>=360]/bestvideo[height>=360]/bestvideo[vcodec^=avc1][height>=240][fps>30]/bestvideo[vcodec^=av01][height>=240][fps>30]/bestvideo[vcodec^=vp9.2][height>=240][fps>30]/bestvideo[vcodec^=vp9][height>=240][fps>30]/bestvideo[height>=240][fps>30]/bestvideo[vcodec^=avc1][height>=240]/bestvideo[vcodec^=av01][height>=240]/bestvideo[vcodec^=vp9.2][height>=240]/bestvideo[vcodec^=vp9][height>=240]/bestvideo[height>=240]/bestvideo[vcodec^=avc1][height>=144][fps>30]/bestvideo[vcodec^=av01][height>=144][fps>30]/bestvideo[vcodec^=vp9.2][height>=144][fps>30]/bestvideo[vcodec^=vp9][height>=144][fps>30]/bestvideo[height>=144][fps>30]/bestvideo[vcodec^=avc1][height>=144]/bestvideo[vcodec^=av01][height>=144]/bestvideo[vcodec^=vp9.2][height>=144]/bestvideo[vcodec^=vp9][height>=144]/bestvideo[height>=144]/bestvideo)+(bestaudio[acodec^=opus]/bestaudio)/best"
    fi

    yt-dlp --sponsorblock-remove all --progress --console-title --format "$format" $extract_audio --no-continue --embed-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --embed-thumbnail --embed-subs --sub-langs "en.*,-live_chat" --concurrent-fragments 5 --output "$output" "$url"

    if [ "$subtitles" = "true" ]; then
        for file in *."$output_format"; do
            whisper "$file"
        done
    fi
}

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

# iTerm2 integration
if [[ "$(uname)" == "Darwin" ]]; then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

