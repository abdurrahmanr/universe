{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  nvimPath = "${config.home.homeDirectory}/flake/home/nvim";
  fishPath = "${config.home.homeDirectory}/flake/home/fish";
in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  home.username = "abdurrahmanr";
  home.homeDirectory = "/home/abdurrahmanr";
  programs.git.enable = true;
  home.stateVersion = "26.11";

  home.packages = with pkgs; [
    nixd
    protonup-qt
    kdePackages.ark
    starship
    fish
    kdePackages.qtstyleplugin-kvantum
    obsidian
    cbonsai
  ];

  services.polkit-gnome.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };

  services.flatpak.packages = [
    {
      appId = "org.libreoffice.LibreOffice";
      origin = "flathub";
    }
  ];

  programs.git.settings.user = {
    name = "abdurrahmanr";
    email = "imanabdurrahmanr@gmail.com";
  };

  programs.discord = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
    options = {
      # Main UI Colors
      default-bg = "#DCD7BA";
      default-fg = "#5b4636";

      # Bars & Notifications
      statusbar-bg = "#e6dcc6";
      statusbar-fg = "#5b4636";
      inputbar-bg = "#e6dcc6";
      inputbar-fg = "#5b4636";
      notification-bg = "#e6dcc6";
      notification-fg = "#5b4636";

      # Completion Menu
      completion-bg = "#efe6cf";
      completion-fg = "#5b4636";
      completion-highlight-bg = "#d8c8a6";
      completion-highlight-fg = "#3e2f23";

      # Index / Outline Menu
      index-bg = "#f4ecd8";
      index-fg = "#5b4636";
      index-active-bg = "#d8c8a6";
      index-active-fg = "#3e2f23";

      # Search Highlights
      highlight-color = "rgba(62, 47, 35, 0.25)";
      highlight-active-color = "#a68b5b";
      highlight-fg = "#3e2f23";

      # Document Recolor (Sepia Shift)
      recolor = true;
      recolor-keephue = true;
      recolor-lightcolor = "#DCD7BA";
      recolor-darkcolor = "#5b4636";

      # Softer visual tweaks for reading
      selection-clipboard = "clipboard";
      guioptions = "s";
    };

  };


  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    plugins = with pkgs; [
      vimPlugins.nvim-treesitter.withAllGrammars
    ];
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "qtct";
    style.name = lib.mkForce "kvantum";
    kvantum.enable = true;
    qt6ctSettings = {
      Appearance = {
        icon_theme = "Papirus-Dark";
        style = "kvantum";
      };
    };
  };

  gtk = {
    enable = true;
  };

  xdg.configFile."umbriel".source = ./umbriel;
  xdg.configFile."kitty".source = ./kitty;

  xdg.configFile."fish".source = config.lib.file.mkOutOfStoreSymlink fishPath;
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;

  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

}
