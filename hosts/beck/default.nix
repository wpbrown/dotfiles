{ self, ...}:
{
  imports = [
    ./configuration.nix
    "${self}/modules/storage/single-disk.nix"   
  ];

  rebeagle.storage.singleDisk.disk = "/dev/sda";  
}