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

common_packages="curl git htop httpie nim ripgrep unzip vim wget zsh"

apt_packages="build-essential clang cmake fd-find llvm libc++-dev libstdc++-10-dev libssl-dev pkg-config zlib1g zlib1g-dev"

brew_packages="bat curl deno exa fd llvm neovim vim wget xh zoxide zld"
brew_cask_packages="alt-tab appcleaner chrome-remote-desktop-host cloudflare-warp firefox flutter github google-chrome iterm2 linear-linear lunar macs-fan-control messenger moonlight mpv neovide nightfall nordvpn parsec qbittorrent rectangle slack stats visual-studio-code zoom"

cargo_packages="bat cargo-audit cargo-cranky cargo-do cargo-edit cargo-expand cargo-nextest cargo-tarpaulin cargo-watch exa fnm hyperfine git-delta skim starship tealdeer xh zoxide"

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
    # Add tap for zld, a linker for Rust on macOS
    $installer tap -q michaeleisel/homebrew-zld

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

# Install mold/sold linker
# https://github.com/rui314/mold
# https://github.com/bluewhalesystems/sold - superset of `mold`, supports macOS/iOS which mold itself does not
mold_url="https://github.com/bluewhalesystems/sold"
operational "- Installing mold/sold linker..."
rm -rf $HOME/mold
git clone $mold_url $HOME/mold
cd $HOME/mold
mkdir build
cd build
sudo ../install-build-deps.sh
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
operational "###         MISCELLANEOUS          ###"
operational "###                                ###"
operational "######################################"

operational "- Hushing login prompts..."
touch $HOME/.hushlogin

operational "- Changing shell to zsh..."
chsh -s $(which zsh)

operational "######################################"
operational "###                                ###"
operational "###           FINISHED!            ###"
operational "###                                ###"
operational "######################################"
