{ self, ... }:
{
  imports = [
    "${self}/users/will"
    "${self}/modules/storage/triple-disk.nix"
    "${self}/modules/system.nix"
    "${self}/modules/desktop"
  ];

  networking.hostName = "turing";

  rebeagle.storage.tripleDisk = {
    mirrorDisk1 = "/dev/sda";
    mirrorDisk2 = "/dev/sdb";
    dataDisk = "/dev/sdc";
  };
}