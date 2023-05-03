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
    cargo binstall --no-confirm --log-level=error $1
}

common_packages="curl git htop unzip vim wget zsh"

apt_packages="build-essential clang cmake fd-find llvm libc++-dev libstdc++-10-dev libssl-dev pkg-config zlib1g zlib1g-dev"

brew_taps="michaeleisel/homebrew-zld epk/epk"
brew_packages="curl deno fd fzf llvm mas neovim postgresql@15 redis vim wget yarn zld"
brew_cask_packages="alt-tab android-platform-tools android-studio appcleaner chrome-remote-desktop-host discord firefox font-sf-mono-nerd-font github google-chrome iina iterm2 keka kekaexternalhelper linear-linear lunar maccy messenger mpv neovide nordvpn openmtp parsec qbittorrent rectangle slack stats visual-studio-code vlc"

cargo_packages="bat bunyan cargo-audit cargo-chef cargo-cmd cargo-cranky cargo-edit cargo-generate cargo-nextest cargo-tarpaulin cargo-tomlfmt cargo-update cargo-watch cross du-dust exa erdtree fnm git-delta hyperfine jaq just ripgrep skim starship tealdeer xh xq zoxide"

installer="UNKNOWN"

operational "######################################"
operational "###                                ###"
operational "###      PACKAGE INSTALLATION      ###"
operational "###                                ###"
operational "######################################"

operational "- Setting up installer..."
if [ "$(uname)" == "Linux" ]; then
    # makes install quieter
    installer="sudo DEBIAN_FRONTEND=noninteractive apt-get"
    operational "- OS is Linux"
    operational "- Installing common packages..."
    $installer update -y -qq
    $installer upgrade -y -qq
    $installer dist-upgrade -y -qq
    for package in $common_packages; do
        operational "\t- Installing $package..."
        $installer install -qq $package >/dev/null
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
    operational "- Updating $installer taps..."
    for tap in $brew_taps; do
        operational "\t- Tapping $tap..."
        $installer tap -q $tap
    done

    operational "- Installing common packages..."
    for package in $common_packages; do
        operational "\t- Installing $package..."
        $installer install -q $package
    done
fi

if [ "$installer" == "UNKNOWN" ]; then
    error "- Unknown OS, must be Linux or MacOS, exiting..."
    exit 1
fi

operational "- Installing $installer packages..."
if [ "$(uname)" == "Linux" ]; then
    $installer update -qq >/dev/null
    $installer upgrade -qq >/dev/null
    for package in $apt_packages; do
        operational "\t- Installing $package..."
        $installer install -qq $package >/dev/null
    done
    $installer autoremove -qq --purge >/dev/null
    $installer -qq clean >/dev/null
elif [ "$(uname)" == "Darwin" ]; then
    $installer update -q
    $installer upgrade -q
    for package in $brew_packages; do
        operational "\t- Installing $package..."
        $installer install -q $package
    done

    operational "- Installing $installer cask packages..."
    for package in $brew_cask_packages; do
        operational "\t- Installing $package..."
        $installer install --cask -q $package
    done
fi

if [ "$(uname)" == "Linux" ]; then
    operational "- Installing neovim on Ubuntu..."
    sudo add-apt-repository ppa:neovim-ppa/stable -y >/dev/null
    $installer update -qq >/dev/null
    $installer install -qq neovim >/dev/null
fi

operational "- Finished installing $installer packages"
echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###     PROGRAMMING LANGUAGES      ###"
operational "###                                ###"
operational "######################################"

# Install mold linker
if [ "$(uname)" == "Linux" ]; then
    operational "- Installing mold linker on Linux..."
    # mold linker
    git clone https://github.com/rui314/mold.git $HOME/mold
    cd $HOME/mold
    ../install-build-deps.sh
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ ..
    cmake --build . -j $(nproc)
    sudo cmake --install .
    cd $HOME
    rm -rf $HOME/mold
elif [ "$(uname)" == "Darwin" ]; then
    operational "- Installing mold/sold linker on macOS..."
    # sold linker
    git clone https://github.com/bluewhalesystems/sold.git $HOME/mold
    cd $HOME/mold
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ ..
    cmake --build . -j $(sysctl -n hw.logicalcpu)
    sudo cmake --install .
    cd $HOME
    rm -rf $HOME/mold
fi

cd $HOME

operational "- Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"

operational "\t- Installing preliminary cargo packages..."
# Cargo config is dependent on sccache
operational "\t\t- Installing sccache..."
cargo install -q sccache

operational "\t- Linking cargo config..."
ln -fs $HOME/dotfiles/rust/config.toml $HOME/.cargo/config.toml

operational "\t- Installing cargo packages..."
# Install cargo-binstall first so as to not need to compile cargo packages but instead use binaries
cargo install -q cargo-binstall
for package in $cargo_packages; do
    if ! [ -x "$(command -v $package)" ]; then
        operational "\t\t- Installing $package..."
        cargo_binstall $package
    fi
done

operational "- Installing Python..."
curl -s https://pyenv.run | bash

if [ "$(uname)" == "Linux" ]; then
    operational "- Installing Deno..."
    curl -fsSL https://deno.land/x/install/install.sh | sh
fi

if [ "$(uname)" == "Darwin" ]; then
    operational "- Installing Flutter..."
    cd $HOME
    git clone https://github.com/flutter/flutter.git -b stable
    export PATH="$PATH:$HOME/flutter/bin"
    flutter config --no-analytics
    flutter precache
    dart --disable-analytics
    yes | flutter doctor --android-licenses
    flutter doctor
fi

operational "- Finished installing programming languages"
echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###        SYMBOLIC LINKING        ###"
operational "###                                ###"
operational "######################################"

operational "- Linking zsh..."
ln -fs $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
ln -fs $HOME/dotfiles/zsh/.zsh_history $HOME/.zsh_history

operational "- Linking vim..."
ln -fs $HOME/dotfiles/vimfiles $HOME/vimfiles
ln -fs $HOME/dotfiles/vimfiles/.vimrc $HOME/.vimrc

operational "- Linking neovim..."
mkdir -p $HOME/.config
ln -fs $HOME/dotfiles/nvim $HOME/.config/nvim

operational "- Linking git..."
ln -fs $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig

operational "- Linking mpv..."
ln -fs $HOME/dotfiles/mpv $HOME/.config/mpv

echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###         MISCELLANEOUS          ###"
operational "###                                ###"
operational "######################################"

operational "- Installing SF Mono Nerd Fonts..."
if [ "$(uname)" == "Darwin" ]; then
    $installer tap epk/epk
    $installer install --cask font-sf-mono-nerd-font
fi

operational "- Hushing login prompts..."
touch $HOME/.hushlogin

operational "- Changing shell to zsh"
chsh -s $(which zsh)

operational "- Sourcing .zshrc..."
source $HOME/.zshrc

operational "######################################"
operational "###                                ###"
operational "###           FINISHED!            ###"
operational "###                                ###"
operational "######################################"

operational "############# Next Steps #############"

operational "- Install Xcode from the App Store"
operational "- Install the following apps:"
operational "\t- Amphetamine"
operational "\t- Amphetamine Enhancer"
