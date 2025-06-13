# macOS Configuration with nix-darwin

This repository contains my macOS configuration using nix-darwin, featuring a modular setup that supports multiple users and machines.

## Features

- Modular configuration structure
- Support for multiple users
- Shared and user-specific settings
- Homebrew integration
- Common development tools and applications
- System-wide and user-specific packages

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.config
cd ~/.config
```

2. Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

3. Restart your terminal

## Manual Setup

If you prefer to set up manually:

1. Install Nix:
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Restart your terminal

3. Install nix-darwin:
```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

4. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.config
cd ~/.config
```

5. Build and switch to the configuration:
```bash
nix build .#darwinConfigurations.sairam-macbook.system
./result/sw/bin/darwin-rebuild switch --flake .#sairam-macbook
```

## Configuration Structure

```
.
├── darwin/
│   ├── modules/
│   │   └── shared.nix      # Shared configuration for all users
│   ├── users/
│   │   └── sairam.nix      # User-specific configuration
│   ├── configuration.nix   # Main system configuration
│   ├── flake.nix          # Flake configuration
│   └── home.nix           # Home Manager configuration
├── setup.sh               # Setup script
└── README.md             # This file
```

## Adding a New User

1. Create a new user configuration file in `darwin/users/`
2. Add their specific settings and packages
3. Add a new machine configuration in `flake.nix`

## Updating Configuration

To update your configuration:

```bash
cd ~/.config
nix flake update
nix build .#darwinConfigurations.sairam-macbook.system
./result/sw/bin/darwin-rebuild switch --flake .#sairam-macbook
```

## Troubleshooting

If you encounter any issues:

1. Check the nix-darwin logs:
```bash
cat /var/log/nix/darwin-rebuild.log
```

2. Try rebuilding with verbose output:
```bash
darwin-rebuild switch --flake .#sairam-macbook -v
```

## License

This configuration is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
