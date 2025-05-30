{ pkgs, config, ... }:
let 
  inherit (config.rebeagle.storage) rootfsPartition;
in
{
  # Don't lecture since the record will be wiped
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  # Don't allow changes to users that will be wiped
  users.mutableUsers = false;

  # We need the exch command from util-linux to atomically swap the rootfs
  boot.initrd.extraFiles.util-linux.source = pkgs.util-linux;

  # Do the rootfs swap
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    echo "* Erasing your darlings *"
    set -ex

    mkdir -p /mnt
    mount ${rootfsPartition} /mnt

    # clean up any orphaned staging subvolumes
    if [ -d /mnt/rootfs_previous.staging ]; then
      btrfs subvolume delete /mnt/rootfs_previous.staging
    fi
    if [ -d /mnt/rootfs.staging ]; then
      btrfs subvolume delete -R /mnt/rootfs.staging
    fi

    # snapshot the last previous rootfs
    if [ -d /mnt/rootfs_previous.old ]; then
      btrfs subvolume delete /mnt/rootfs_previous.old
    fi
    if [ -d /mnt/rootfs_previous ]; then
      btrfs subvolume snapshot -r /mnt/rootfs_previous /mnt/rootfs_previous.old
    fi

    # stage the current rootfs as the new previous rootfs
    btrfs subvolume snapshot /mnt/rootfs /mnt/rootfs_previous.staging

    # stage a new blank rootfs
    btrfs subvolume snapshot /mnt/rootfs_blank /mnt/rootfs.staging

    # copy the current machine-id to the new staging rootfs
    if [ -f /mnt/rootfs/etc/machine-id ]; then
      mkdir -p /mnt/rootfs.staging/etc
      cp -a /mnt/rootfs/etc/machine-id /mnt/rootfs.staging/etc/machine-id
    fi

    # atomic exchange the current rootfs with the new staging rootfs
    /util-linux/bin/exch /mnt/rootfs.staging /mnt/rootfs

    # atomic exchange the previous rootfs with the new staging previous rootfs
    if [ -d /mnt/rootfs_previous ]; then
      /util-linux/bin/exch /mnt/rootfs_previous.staging /mnt/rootfs_previous
    else
      mv /mnt/rootfs_previous.staging /mnt/rootfs_previous
    fi

    # clean up
    btrfs subvolume delete -R /mnt/rootfs.staging
    if [ -d /mnt/rootfs_previous.staging ]; then
      btrfs subvolume delete /mnt/rootfs_previous.staging
    fi

    umount /mnt
    set +ex
    echo "* Done* "
  '';

  # Ensure these are all available for activation. Some others like /var/log are 
  # automatically needed for boot, but we need to explicitly set these.
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/lib/sops-nix".neededForBoot = true;
  fileSystems."/var/lib/systemd".neededForBoot = true;
}
