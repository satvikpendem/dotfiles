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

function cargo_binstall {
    cargo binstall --no-confirm $1 >/dev/null 2>&1
}

common_packages="curl exa git htop httpie neovim nim ripgrep vim wget xh zoxide zsh"

apt_packages="batcat build-essential clang cmake fd-find llvm"

brew_packages="bat curl deno fd llvm neovim vim wget zld"
brew_cask_packages="alt-tab appcleaner chrome-remote-desktop-host cloudflare-warp firefox flutter github google-chrome iterm2 linear-linear lunar macs-fan-control messenger moonlight mpv neovide nightfall nordvpn parsec qbittorrent rectangle slack stats visual-studio-code zoom"

cargo_packages="cargo-audit cargo-cranky cargo-do cargo-edit cargo-tarpaulin cargo-watch fnm hyperfine git-delta skim tealdeer"

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
    for package in $common_packages; do
        operational "\t- Installing $package..."
        $installer install -y $package
    done
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
    for package in $common_packages; do
        operational "\t- Installing $package..."
        $installer install -q $package
    done
fi

if [ $installer == "UNKNOWN" ]; then
    error "- Unknown OS, must be Linux or MacOS, exiting..."
    exit 1
fi

operational "- Installing $installer packages..."
if [ "$(uname)" == "Linux" ]; then
    $installer update -y
    $installer upgrade -y
    for package in $apt_packages; do
        operational "\t- Installing $package..."
        $installer install -y $package
    done
    $installer autoremove -y --purge
    $installer -y clean
elif [ "$(uname)" == "Darwin" ]; then
    # Add tap for zld, a linker for Rust on macOS
    $installer tap -q michaeleisel/homebrew-zld >/dev/null 2>&1

    $installer update -q >/dev/null 2>&1
    $installer upgrade -q >/dev/null 2>&1
    for package in $brew_packages; do
        operational "\t- Installing $package..."
        $installer install -q $package >/dev/null 2>&1
    done

    operational "- Installing $installer cask packages..."
    for package in $brew_cask_packages; do
        operational "\t- Installing $package..."
        $installer install --cask -q $package >/dev/null 2>&1
    done
fi

if [ "$(uname)" == "Linux" ]; then
    operational "- Installing neovim on Ubuntu..."
    sudo add-apt-repository ppa:neovim-ppa/stable
    $installer update -y
    $installer install -y neovim
fi

operational "- Finished installing $installer packages"
echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###     PROGRAMMING LANGUAGES      ###"
operational "###                                ###"
operational "######################################"

# Install mold linker
# On macOS, this is already installed through Homebrew
if [ "$(uname)" == "Linux" ]; then
    operational "- Installing mold linker on Linux..."
    # mold linker
    git clone https://github.com/rui314/mold.git $HOME/mold
    cd $HOME/mold
    git checkout v1.4.0 # latest stable release
    make -s -j$(nproc) CXX=clang++
    sudo make -s install
    cd $HOME
    rm -rf $HOME/mold
fi

operational "- Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
source "$HOME/.cargo/env"

operational "\t- Installing preliminary cargo packages..."
# Cargo config is dependent on sccache
operational "\t\t- Installing sccache..."
cargo install -q sccache

operational "\t- Linking cargo config..."
ln -Fs $HOME/dotfiles/rust/config.toml ~/.cargo/config.toml

operational "\t- Installing cargo packages..."
# Install cargo-binstall first so as to not need to compile cargo packages but instead use binaries
cargo install -q cargo-binstall
for package in $cargo_packages; do
    operational "\t\t- Installing $package..."
    cargo_binstall $package
done

operational "- Installing Python..."
curl -s https://pyenv.run | bash >/dev/null 2>&1

if [ "$(uname)" == "Linux" ]; then
    operational "- Installing Deno..."
    curl -fsSL https://deno.land/x/install/install.sh | sh
fi

operational "- Finished installing programming languages"
echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###        SYMBOLIC LINKING        ###"
operational "###                                ###"
operational "######################################"

operational "- Linking zsh..."
ln -Fs $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
ln -Fs $HOME/dotfiles/zsh/.zsh_history $HOME/.zsh_history

operational "- Linking vim..."
ln -Fs $HOME/dotfiles/vimfiles $HOME/vimfiles
ln -Fs $HOME/dotfiles/vimfiles/vimrc $HOME/.vimrc

operational "- Linking neovim..."
mkdir -p $HOME/.config
ln -Fs $HOME/dotfiles/nvim $HOME/.config/nvim

operational "- Linking git..."
ln -Fs $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig

echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###           FINISHED!            ###"
operational "###                                ###"
operational "######################################"
