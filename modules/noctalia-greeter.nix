{ pkgs, ... }:
let
  saturnianNight = pkgs.runCommand "saturnian-night" { } ''
    mkdir -p $out/share/icons/Saturnian-Night
    cp -r ${../home/cursors/Saturnian-Night}/* $out/share/icons/Saturnian-Night/
  '';

in
{
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 24;
      keyboard.layout = "us";
    };
    cursorTheme = {
      name = "Saturnian-Night";
      package = saturnianNight;
    };
  };
}
