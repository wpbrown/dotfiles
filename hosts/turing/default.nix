{ self, ... }:
{
  imports = [
    "${self}/modules/storage/triple-disk.nix"
    "${self}/modules/system.nix"
    "${self}/modules/desktop"
  ];

  rebeagle.storage.tripleDisk = {
    mirrorDisk1 = "/dev/sda";
    mirrorDisk2 = "/dev/sdb";
    dataDisk = "/dev/sdc";
  };
}