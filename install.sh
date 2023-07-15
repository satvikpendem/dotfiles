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

common_packages="cmake curl git htop llvm unzip vim wget zsh"

apt_packages="build-essential clang fd-find libc++-dev libstdc++-10-dev libssl-dev pkg-config zlib1g zlib1g-dev"

brew_taps="michaeleisel/homebrew-zld epk/epk"
brew_packages="deno fd llvm neovim yt-dlp zld"
brew_cask_packages="alt-tab appcleaner chrome-remote-desktop-host discord firefox font-sf-mono-nerd-font github google-chrome iterm2 linear-linear lunar maccy messenger neovide nordvpn parsec qbittorrent rectangle slack stats visual-studio-code"

cargo_packages="bat cargo-audit cargo-cranky cargo-do cargo-edit cargo-expand cargo-nextest cargo-tarpaulin cargo-update cargo-watch erdtree exa fnm hyperfine git-delta ripgrep skim starship tealdeer xh zoxide"

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
    $installer install -y -qq $common_packages
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

if [ "$installer" == "UNKNOWN" ]; then
    error "- Unknown OS, must be Linux or MacOS, exiting..."
    exit 1
fi

operational "- Installing $installer packages..."
if [ "$(uname)" == "Linux" ]; then
    $installer update -qq >/dev/null
    $installer upgrade -qq >/dev/null
    $installer install -qq $common_packages
    $installer autoremove -qq --purge >/dev/null
    $installer -qq clean >/dev/null
elif [ "$(uname)" == "Darwin" ]; then
    for tap in $brew_taps; do
        operational "\t- Tapping $tap..."
        $installer tap -q $tap
    done

    $installer update -q
    $installer upgrade -q
    $installer install -q --no-quarantine $brew_packages

    operational "- Installing $installer cask packages..."
    $installer install --cask -q --no-quarantine $brew_cask_packages
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

# Install mold/sold linker
# https://github.com/rui314/mold
# https://github.com/bluewhalesystems/sold - superset of `mold`, supports macOS/iOS which mold itself does not
mold_url="https://github.com/bluewhalesystems/sold.git"
operational "- Installing mold/sold linker..."
rm -rf $HOME/mold
git clone $mold_url $HOME/mold
mkdir $HOME/mold/build
cd $HOME/mold/build
# Only need to install build dependencies on Linux
if [ "$(uname)" == "Linux" ]; then
    sudo ../install-build-deps.sh
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ ..
# Different ways to access number of CPU cores/threads on Linux versus macOS
if [ "$(uname)" == "Linux" ]; then
    cmake --build . -j $(nproc)
elif [ "$(uname)" == "Darwin" ]; then
    cmake --build . -j $(sysctl -n hw.logicalcpu)
else
    cmake --build .
fi
# sold requires a license file to be present in the root directory
touch ../LICENSE
sudo cmake --install .
cd $HOME
rm -rf $HOME/mold

cd $HOME

operational "- Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"

operational "\t- Installing preliminary cargo packages..."
# Cargo config is dependent on sccache
operational "\t\t- Installing sccache..."
cargo install sccache

operational "\t- Linking cargo config..."
ln -fs $HOME/dotfiles/rust/config.toml $HOME/.cargo/config.toml

operational "\t- Installing cargo packages..."
# Install cargo-binstall first so as to not need to compile cargo packages but instead use binaries
cargo install cargo-binstall
source "$HOME/.cargo/bin"
cargo_binstall $cargo_packages

if [ "$(uname)" == "Linux" ]; then
    operational "- Installing Deno..."
    curl -fsSL https://deno.land/x/install/install.sh | sh
fi

# Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:~/flutter/bin"
flutter precache
flutter doctor

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

echo -e "\n"

operational "######################################"
operational "###                                ###"
operational "###          MISCELLANEA           ###"
operational "###                                ###"
operational "######################################"

operational "- Hushing login prompts..."
if [ "$(uname)" == "Linux" ]; then
    touch $HOME/.hushlogin
fi

operational "- Changing shell to zsh..."
chsh -s $(which zsh)

if [ "$(uname)" == "Darwin" ]; then
    operational "- Disabling macOS quirks..."
    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

    # Finder
    defaults write com.apple.finder "QuitMenuItem" -bool "true"
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
    defaults write com.apple.finder "ShowPathbar" -bool "true"
    defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
    defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
    defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true"
    killall Finder

    # Safari
    defaults write com.apple.safari "ShowFullURLInSmartSearchField" -bool "true" && killall Safari

    # Miscellanea
    defaults write com.apple.screencapture "disable-shadow" -bool "true"
    defaults write com.apple.dock "autohide-delay" -float "0" && killall Dock
    chflags nohidden ~/Library/
fi

operational "######################################"
operational "###                                ###"
operational "###           FINISHED!            ###"
operational "###                                ###"
operational "######################################"

operational "######################################"
operational "###                                ###"
operational "###          NEXT STEPS            ###"
operational "###                                ###"
operational "######################################"

operational "- Install the following:"
operational "\t- Smooth Video Project (SVP)"

operational "- Configure the following:"
operational "\t- iTerm2"
operational "\t- VSCode"
operational "\t- Remap Caps Lock to Escape"
