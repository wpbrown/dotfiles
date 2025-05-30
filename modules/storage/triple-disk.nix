{
  lib,
  disko,
  config,
  ...
}:
{
  options.rebeagle.storage.tripleDisk = {
    mirrorDisk1 = lib.mkOption {
      type = disko.lib.optionTypes.absolute-pathname;
    };
    mirrorDisk2 = lib.mkOption {
      type = disko.lib.optionTypes.absolute-pathname;
    };
    dataDisk = lib.mkOption {
      type = disko.lib.optionTypes.absolute-pathname;
    };
  };
  options.rebeagle.storage.rootfsPartition = lib.mkOption {
    type = lib.types.path;
    default = "/dev/disk/by-partlabel/turing-mirror1";
    readonly = true;
  };

  config =
    let
      cfg = config.rebeagle.storage.tripleDisk;
    in
    {
      disko.devices = {
        # terrible hack to ensure that the secondary disk is formatted first
        # mirrorDisk1 depends on mirrorDisk2. 
        # there is no native multi-disk btrfs support in disko yet.
        _meta.deviceDependencies = {
          disk = {
            mirrorDisk1 = [
              [
                "disk"
                "mirrorDisk2"
              ]
            ];
          };
        };
        disk = {
          mirrorDisk1 = {
            device = cfg.mirrorDisk1;
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                ESP1 = {
                  priority = 1;
                  name = "ESP";
                  label = "ESP";
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                root1 = {
                  label = "turing-mirror1";
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" "-d raid1 -m raid1" "/dev/disk/by-partlabel/turing-mirror2" ];
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
                  label = "turing-swap1";
                  content = {
                    type = "swap";
                  };
                };
              };
            };
          };
          mirrorDisk2 = {
            device = cfg.mirrorDisk2;
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                ESP2 = {
                  priority = 1;
                  name = "ESP_BK";
                  label = "ESP_BK";
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/mnt/boot_bk";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                root2 = {
                  label = "turing-mirror2";
                  size = "100%";
                };
                swap = {
                  size = "1G";
                  label = "turing-swap2";
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
