#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}Error:${NC} $1"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is only for macOS"
    exit 1
fi

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    print_status "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    print_warning "Please restart your terminal and run this script again"
    exit 0
fi

# Create config directory if it doesn't exist
CONFIG_DIR="$HOME/.config"
if [[ ! -d "$CONFIG_DIR" ]]; then
    print_status "Creating config directory..."
    mkdir -p "$CONFIG_DIR"
fi

# Clone the repository if it doesn't exist
if [[ ! -d "$CONFIG_DIR/.git" ]]; then
    print_status "Cloning dotfiles repository..."
    git clone https://github.com/yourusername/dotfiles.git "$CONFIG_DIR"
fi

# Change to config directory
cd "$CONFIG_DIR"

# Install nix-darwin if not already installed
if [[ ! -f /run/current-system/sw/bin/darwin-rebuild ]]; then
    print_status "Installing nix-darwin..."
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
fi

# Build and switch to the configuration
print_status "Building and switching to the configuration..."
nix build .#darwinConfigurations.sairam-macbook.system
./result/sw/bin/darwin-rebuild switch --flake .#sairam-macbook

print_status "Setup complete! Please restart your terminal." 