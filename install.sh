#!/bin/bash

# Color output with tput

BOLD=$(tput bold)
OPERATIONAL=$(tput setaf 2)
WARNING=$(tput setaf 3)
ERROR=$(tput setaf 1)
BOLD_OPERATIONAL=$(
    tput bold
    tput setaf 2
)
BOLD_WARNING=$(
    tput bold
    tput setaf 3
)
BOLD_ERROR=$(
    tput bold
    tput setaf 1
)

function operational {
    echo -e "${BOLD_OPERATIONAL}$1${RESET}"
}

function warning {
    echo -e "${BOLD_WARNING}$1${RESET}"
}

function error {
    echo -e "${BOLD_ERROR}$1${RESET}"
}

common_packages="git vim zsh curl wget htop ripgrep"
apt_packages="build-essential cmake batcat"
brew_packages="bat curl exa fd fnm git httpie mold neovim ripgrep tealdeer vim wget xh zoxide"
brew_cask_packages="alt-tab appcleaner chrome-remote-desktop-host cloudflare-warp firefox flutter github google-chrome iterm2 linear-linear lunar macs-fan-control messenger moonlight mpv nightfall nordvpn parsec qbittorrent rectangle slack stats visual-studio-code zoom"

installer="UNKNOWN"

operational "######################################"
operational "###                                ###"
operational "###      PACKAGE INSTALLATION      ###"
operational "###                                ###"
operational "######################################"

operational "- Setting up installer..."
if [ "$(uname)" == "Linux" ]; then
    installer="sudo apt"
    operational "- OS is Linux"
    operational "- Installing common packages..."
    $installer install $common_packages
elif [ "$(uname)" == "Darwin" ]; then
    operational "- OS is macOS"
    # Install `brew` (brew.sh) if not installed
    if [ ! -f /opt/homebrew/bin/brew ]; then
        operational "- Installing Homebrew..."
        # Set as non-interactive to avoid prompts
        NONINTERACTIVE=1 sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        warning "- brew is already installed"
    fi
    installer="brew"
    operational "- Installing common packages..."
    $installer install -q $common_packages
fi

if [ $installer == "UNKNOWN" ]; then
    error "- Unknown OS, must be Linux or MacOS, exiting..."
    exit 1
fi

operational "- Installing $installer packages..."
if [ "$(uname)" == "Linux" ]; then
    $installer update -y
    $installer upgrade -y
    $installer install -y $apt_packages
    $installer autoremove -y --purge
    $installer -y clean
elif [ "$(uname)" == "Darwin" ]; then
    $installer update
    $installer upgrade
    $installer install -q $brew_packages
fi

operational "- Finished installing $installer packages"
echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###        SYMBOLIC LINKING        ###"
operational "###                                ###"
operational "######################################"
