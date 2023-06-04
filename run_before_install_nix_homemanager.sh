#!/bin/bash

# Install nix if not installed.
if [ ! command -v nix &> /dev/null ]
then
	echo "Nix is not installed. Starting installation"
	curl -L https://nixos.org/nix/install | sh -s -- --daemon
	echo "Nix has been installed"
else
	echo "Nix was already installed"
fi

# Install nixGL if not installed.
if [ ! command -v nixGL &> /dev/null ]
then
	echo "nixGL is not installed."
	nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
	nix-channel --update
	nix-env -iA nixgl.auto.nixGLDefault
	echo "nixGL has been installed"
else
	echo "nixGL was already installed."
fi

# Install home-manager if not installed.
if [ ! command -v home-manager &> /dev/null ]
then
	echo "Home-manager is not installed."
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
	echo "Home-manager has been installed."
else
	echo "Home-manager was already installed"
fi
