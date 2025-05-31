{
  lib,
  disko,
  config,
  ...
}:
{
  options.rebeagle.storage.singleDisk = {
    disk = lib.mkOption {
      type = disko.lib.optionTypes.absolute-pathname;
    };
  };
  options.rebeagle.storage.rootfsPartition = lib.mkOption {
    type = lib.types.path;
    default = "/dev/disk/by-partlabel/disk-main-root";
    readOnly = true;
  };

  config =
    let
      cfg = config.rebeagle.storage.singleDisk;
    in
    {
      disko.devices = {
        disk = {
          main = {
            device = cfg.disk;
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  priority = 1;
                  name = "ESP";
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                root = {
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/rootfs" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/";
                      };
                      "/home" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/home";
                      };
                      "/home/will" = { };
                      "/nix" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/nix";
                      };
                      "/sops-nix" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/var/lib/sops-nix";
                      };
                      "/log" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/var/log";
                      };
                      "/systemd" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/var/lib/systemd";
                      };
                      "/persist" = {
                        mountOptions = [
                          "noatime"
                        ];
                        mountpoint = "/persist";
                      };
                    };
                    mountOptions = [
                      "noatime"
                    ];
                    mountpoint = "/mnt/os_part";
                  };
                };
                swap = {
                  size = "1G";
                  content = {
                    type = "swap";
                  };
                };
              };
            };
          };
        };
      };
    };
}
