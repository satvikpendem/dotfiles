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

common_packages="git vim zsh curl wget htop ripgrep"
apt_packages="build-essential cmake batcat"
brew_packages="bat curl exa fd fnm git httpie mold neovim ripgrep tealdeer vim wget xh zoxide"
brew_cask_packages="alt-tab appcleaner chrome-remote-desktop-host cloudflare-warp firefox flutter github google-chrome iterm2 linear-linear lunar macs-fan-control messenger moonlight mpv nightfall nordvpn parsec qbittorrent rectangle slack stats visual-studio-code zoom"

installer="UNKNOWN"

echo -e $BOLD_OPERATIONAL "######################################"
echo -e $BOLD_OPERATIONAL "###                                ###"
echo -e $BOLD_OPERATIONAL "###      PACKAGE INSTALLATION      ###"
echo -e $BOLD_OPERATIONAL "###                                ###"
echo -e $BOLD_OPERATIONAL "######################################"

echo -e $BOLD_OPERATIONAL "- Setting up installer..."
if [ "$(uname)" == "Linux" ]; then
    installer="sudo apt"
    echo -e $BOLD_OPERATIONAL "- OS is Linux"
    echo -e $BOLD_OPERATIONAL "- Installing common packages..."
    $installer install $common_packages
elif [ "$(uname)" == "Darwin" ]; then
    echo -e $BOLD_OPERATIONAL "- OS is macOS"
    # Install `brew` (brew.sh) if not installed
    if [ ! -f /opt/homebrew/bin/brew ]; then
        echo -e $BOLD_OPERATIONAL "- Installing Homebrew..."
        # Set as non-interactive to avoid prompts
        NONINTERACTIVE=1 sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo -e $BOLD_WARNING "- brew is already installed"
    fi
    installer="brew"
    echo -e $BOLD_OPERATIONAL "- Installing common packages..."
    $installer install -q $common_packages
fi

if [ $installer == "UNKNOWN" ]; then
    echo -e $BOLD_ERROR "- Unknown OS, must be Linux or MacOS, exiting..."
    exit 1
fi

echo -e $BOLD_OPERATIONAL "- Installing $installer packages..."
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

echo -e $BOLD_OPERATIONAL "- Finished installing $installer packages"
echo -e "\n"

echo -e $BOLD_OPERATIONAL "######################################"
echo -e $BOLD_OPERATIONAL "###                                ###"
echo -e $BOLD_OPERATIONAL "###        SYMBOLIC LINKING        ###"
echo -e $BOLD_OPERATIONAL "###                                ###"
echo -e $BOLD_OPERATIONAL "######################################"
