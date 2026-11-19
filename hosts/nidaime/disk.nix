{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S6P6NJ0T109860K";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
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
            mountpoint = "/";
            subvolumes = {
              "/home" = {
                mountpoint = "/home";
              };
              "/nix" = {
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
  };
}
