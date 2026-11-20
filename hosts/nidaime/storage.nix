{
  disko.devices = {
    disk = {
      games = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S6P6NJ0T109860K";
        content = {
          type = "gpt";
          partitions = {
            games = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/mnt/games";
                mountOptions = [
                  "defaults"
                  "exec"
                  "nofail"
                ];
              };
            };
          };
        };
      };
    };
  };
}
