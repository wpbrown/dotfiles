#!/usr/bin/env bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
root_dir=$(readlink -f "$script_dir/..")

set -euxo pipefail

# Setup inputs
target_host="$1"

# Setup and mount the system at /mnt
nix-shell -p disko --run \
  "disko --flake 'git+file://${root_dir}?submodules=true#${target_host}' --mode 'destroy,format,mount'"

# Install the sops-nix key
chmod 700 /mnt/var/lib/sops-nix
cp keys.txt /mnt/var/lib/sops-nix/keys.txt
chmod 600 /mnt/var/lib/sops-nix/keys.txt

# Configure the file system
btrfs property set /mnt/nix compression zstd

# Prepare for impermanance
btrfs subvolume snapshot -r /mnt/mnt/os_part/rootfs /mnt/mnt/os_part/rootfs_blank

# Install the system to /mnt
nixos-install --no-channel-copy --no-root-password --flake "git+file://${root_dir}?submodules=1#${target_host}"
