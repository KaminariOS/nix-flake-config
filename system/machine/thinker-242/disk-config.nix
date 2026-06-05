{...}: {
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "umask=0077"
              ];
            };
          };
          swap = {
            size = "16G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    zpool.zroot = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "on";
      };
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        compression = "zstd";
        mountpoint = "none";
        xattr = "sa";
        "com.sun:auto-snapshot" = "false";
      };
      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
        };
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
        };
      };
    };
  };
}
