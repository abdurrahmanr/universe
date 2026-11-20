{
  config,
  pkgs,
  inputs,
  ...
}:
let
  nvimPath = "${config.home.homeDirectory}/universe/home/nvim";
  fishPath = "${config.home.homeDirectory}/universe/home/fish";
  umbrielPath = "${config.home.homeDirectory}/universe/home/umbriel";
  kittyPath = "${config.home.homeDirectory}/universe/home/kitty";
  starshipPath = "${config.home.homeDirectory}/universe/home/starship.toml";
  noctaliaPath = "${config.home.homeDirectory}/universe/home/noctalia";

  saturnianNight = pkgs.runCommand "saturnian-night" { } ''
    mkdir -p $out/share/icons/Saturnian-Night
    cp -r ${./cursors/Saturnian-Night}/* $out/share/icons/Saturnian-Night/
  '';
in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  home.username = "abdurrahmanr";
  home.homeDirectory = "/home/abdurrahmanr";
  programs.git.enable = true;
  home.stateVersion = "26.11";

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    nixd
    protonup-qt
    kdePackages.ark
    kdePackages.qt6ct
    starship
    fish
    obsidian
    cbonsai
    papirus-folders
  ];

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
  };

  home.pointerCursor = {
    enable = true;
    name = "Saturnian-Night";
    package = saturnianNight;
    size = 24;

    gtk.enable = true;
  };

  services.polkit-gnome.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
    };
  };

  services.flatpak.packages = [
    {
      appId = "org.libreoffice.LibreOffice";
      origin = "flathub";
    }
    {
      appId = "org.freedownloadmanager.Manager";
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

  xdg.configFile."umbriel".source = config.lib.file.mkOutOfStoreSymlink umbrielPath;
  xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink kittyPath;

  xdg.configFile."fish".source = config.lib.file.mkOutOfStoreSymlink fishPath;
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;

  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink starshipPath;
  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink noctaliaPath;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

}
