{ pkgs, ... }:

{

  niri-flake.cache.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

}
