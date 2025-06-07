{ lib, ... }:
{
  # Start with turing as the base configuration
  imports = [
    ../turing
  ];

  # Override the hostname
  networking.hostName = lib.mkForce "turingv";

  # Override storage for QEMU virtual disks
  rebeagle.storage.tripleDisk = {
    mirrorDisk1 = lib.mkForce "/dev/sda";
    mirrorDisk2 = lib.mkForce "/dev/sdb";
    dataDisk = lib.mkForce "/dev/sdc";
  };

  # Mount home from the host
  fileSystems."/mnt/home_bk" = {
    device = "lxd_home";
    fsType = "9p";
    options = [
      "trans=virtio"
    ];
  };
  
  # Mount persist from the host
  fileSystems."/mnt/persist_bk" = {
    device = "lxd_persist";
    fsType = "9p";
    options = [
      "trans=virtio"
    ];
  };
  
  # Mount dotfiles from the host
  fileSystems."/home/will/dev/dotfiles" = {
    device = "lxd_dotfiles";
    fsType = "9p";
    options = [
      "trans=virtio"
      "nofail"
    ];
  };
}