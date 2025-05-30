#!/usr/bin/env bash

lxc init nixos --empty --vm -c security.secureboot=false -c limits.cpu=4 -c limits.memory=12GB
lxc config device add nixos dotfiles disk source=/mnt/lxd_part/mydata/devx/dotfiles path=dotfiles
lxc config device add nixos installer disk source=/home/will/downloads/nixos-graphical-25.05.802491.7c43f080a7f2-x86_64-linux.iso boot.priority=2
lxc config device override nixos root size=30GB

echo "Start VM: lxc start nixos --console=vga"