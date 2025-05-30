{ lib, ... }:
{
  # Start with turing as the base configuration
  imports = [
    ../turing
  ];

  # Override storage for QEMU virtual disks
  rebeagle.storage.tripleDisk = {
    mirrorDisk1 = lib.mkForce "/dev/sda";
    mirrorDisk2 = lib.mkForce "/dev/sdb";
    dataDisk = lib.mkForce "/dev/sdc";
  };
}