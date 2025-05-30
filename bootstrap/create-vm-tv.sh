#!/usr/bin/env bash

lxc init nixos2 --empty --vm -c security.secureboot=false -c limits.cpu=4 -c limits.memory=12GB
lxc config device add nixos2 dotfiles disk source=/mnt/lxd_part/mydata/devx/dotfiles path=dotfiles
lxc config device add nixos2 installer disk source=/home/will/downloads/nixos-graphical-25.05.802491.7c43f080a7f2-x86_64-linux.iso boot.priority=2
lxc config device override nixos2 root size=20GB

lxc storage volume create default nixos2d2 size=20GiB --type=block
lxc config device add nixos2 vold2 disk pool=default source=nixos2d2

lxc storage volume create default nixos2d3 size=10GiB --type=block
lxc config device add nixos2 vold3 disk pool=default source=nixos2d3

echo "Start VM: lxc start nixos2 --console=vga"