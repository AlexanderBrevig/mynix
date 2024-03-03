#!/usr/bin/env bash
set -e

pushd ~/github.com/mynix
hx nixos/packages.nix
alejandra . >/dev/null
git diff -U0 ./**.nix

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --upgrade --flake . &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

# Get current generation metadata
current=$(nixos-rebuild list-generations --flake . | grep current)

# Commit all changes witih the generation metadata
git commit -am "chore: $current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
