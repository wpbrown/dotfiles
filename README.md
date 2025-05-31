# Machines

Installation is performed by booting a NixOS live USB, pulling the dotfiles repo,
creating the sops-nix decryption key, and running the bootstrap script.

```
nix-shell -p gh
git auth login -p https -h github.com -w
git clone --recurse-submodules https://github.com/wpbrown/dotfiles.git

# paste the sops key
nano keys.txt

# specify the host being installed
sudo ./dotfiles/bootstrap/install.sh <hostname>
```

## Beck

Create a single-disk small test VM with KDE.

```
./bootstrap/create-vm.sh
```

Instead of pulling the config from GitHub, it can be retrieved from the host.

```
mkdir secrets dotfiles
sudo mount -t 9p -o trans=virtio lxd_secrets secrets
sudo mount -t 9p -o trans=virtio lxd_dotfiles dotfiles
cd secrets
sudo ../dotfiles/bootstrap/install.sh <hostname>
```

The default password is `test`.

## Hopper

The Minisforums UN100L BIOS is not recognizing the NixOS 25.05 media EFI.

Plug in 2 drives, 1 NixOS and 1 Ubuntu. Use chainload in GRUB to boot the
NixOS media from the Ubuntu media.

* Boot a Ubuntu install
* Enter the GRUB console
* set root=(cd0)
* chainload /BOOT/EFI/something
* boot

## Turing

Not done yet.

## TuringV

Virtual version of Turing.

