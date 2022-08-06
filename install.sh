#!/bin/bash

common_packages="git vim zsh curl wget htop ripgrep"

apt_packages="build-essential cmake batcat"

brew_packages=(
    "bat"        # Clone of cat(1) with syntax highlighting and Git integration
    "curl"       # CLI for HTTP(S) requestl
    "exa"        # Modern replacement for 'ls'
    "fd"         # Simple, fast and user-friendly alternative to find
    "fnm"        # Fast and simple Node.js version manager
    "git"        # Distributed revision control system
    "httpie"     # User-friendly cURL replacement (command-line HTTP client)
    "mkvtoolnix" # Matroska media files manipulation tools
    "mold"       # Modern Linker
    "neovim"     # Ambitious Vim-fork focused on extensibility and agility
    "ripgrep"    # Search tool like grep and The Silver Searcher
    "tealdeer"   # Very fast implementation of tldr in Rust
    "vim"        # Vi 'workalike' with many additional features
    "wget"       # GNU's general-purpose web-client
    "xh"         # Friendly and fast tool for sending HTTP requests
    "zoxide"     # Shell extension to navigate your filesystem faster
)

brew_cask_packages=(
    "alt-tab"                    # (AltTab) Enable Windows-like alt-tab
    "appcleaner"                 # (FreeMacSoft AppCleaner) Application uninstaller
    "chrome-remote-desktop-host" # (Chrome Remote Desktop) Remotely access another computer through the Google Chrome browser
    "cloudflare-warp"            # (Cloudflare WARP) Free app that makes your Internet safer
    "firefox"                    # (Mozilla Firefox) Web browser
    "flutter"                    # (Flutter SDK) UI toolkit for building applications for mobile, web and desktop
    "github"                     # (GitHub Desktop) Desktop client for GitHub repositories
    "google-chrome"              # (Google Chrome) Web browser
    "iterm2"                     # (iTerm2) Terminal emulator as alternative to Apple's Terminal app
    "linear-linear"              # (Linear) App to manage software development and track bugs
    "lunar"                      # (Lunar) Adaptive brightness for external displays
    "macs-fan-control"           # (Macs Fan Control) Controls and monitors all fans on Apple computers
    "messenger"                  # (Facebook Messenger) Native desktop app for Messenger (formerly Facebook Messenger)
    "moonlight"                  # (Moonlight) GameStream client
    "mpv"                        # Media player based on MPlayer and mplayer2
    "nightfall"                  # (Nightfall) Menu bar utility for toggling dark mode
    "nordvpn"                    # (NordVPN) VPN client for secure internet access and private browsing
    "parsec"                     # (Parsec) Remote desktop
    "qbittorrent"                # (qBittorrent) Peer to peer Bitorrent client
    "rectangle"                  # (Rectangle) Move and resize windows using keyboard shortcuts or snap areas
    "slack"                      # (Slack) Team communication and collaboration software
    "stats"                      # (Stats) System monitor for the menu bar
    "visual-studio-code"         # (Microsoft Visual Studio Code, VS Code) Open-source code editor
    "zoom"                       # (Zoom.us) Video communication and virtual meeting platform
)

installer = "UNKNOWN"

echo "Setting up installer..."
if [ "$(uname)" == "Linux" ]; then
    installer = "sudo apt"
    echo "OS is Linux"
elif [ "$(uname)" == "Darwin" ]; then
    echo "OS is macOS"
    # Install `brew` (brew.sh) if not installed
    if [ ! -f /usr/local/bin/brew ]; then
        echo "Installing Homebrew..."
        # Set as non-interactive to avoid prompts
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "brew is already installed"
    fi
    installer = "brew"
fi

if $installer == "UNKNOWN"; then
    echo "Unknown OS, must be Linux or MacOS, exiting..."
    exit 1
fi

echo "Installing common packages..."
$installer install $common_packages

echo "Installing $installer packages..."
if [ "$(uname)" == "Linux" ]; then
    $installer update -y
    $installer upgrade -y
    $installer install -y $apt_packages
    $installer autoremove -y --purge
    $installer -y clean
elif [ "$(uname)" == "Darwin" ]; then
    $installer update
    $installer upgrade
    $installer install $brew_packages
fi
