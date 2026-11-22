{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./storage.nix
    ../../modules/umbriel.nix
    ../../modules/noctalia.nix
    ../../modules/noctalia-greeter.nix
    # ../../modules/gui/lutris.nix
    ../../modules/gui/steam.nix
    ../../modules/helium.nix
    ../../modules/luciole.nix
  ];

  virtualisation.vmVariantWithDisko = {
    users.users.abdurrahmanr.initialPassword = "test";
    users.users.root.initialPassword = "test";
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.desktopManager.plasma6.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.trusted-users = [
    "root"
    "abdurrahmanr"
  ];

  networking.hostName = "nidaime";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Makassar";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = false;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
  ];
  services.cloudflare-warp.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig = {
      "99-disable-suspend" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };
  };

  users.users."abdurrahmanr" = {
    isNormalUser = true;
    description = "Abdurrahman Rahim";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.nix-ld.enable = true;

  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets.github-ssh = {
    file = ../../secrets/github-ssh.age;
    path = "/home/abdurrahmanr/.ssh/github";
    owner = "abdurrahmanr";
    mode = "0400";
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    kitty
    evtest
    kdePackages.qtsvg
    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
    btop-cuda
    kdePackages.qtsvg
    efibootmgr
    kdePackages.qt6ct
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.systemsettings
    nwg-look
    fetch
    grim
    wl-clipboard
    slurp
    proton-pass
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default

    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    })
  ];

  services.gnome.gnome-keyring.enable = true;

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };

  security.polkit.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts = {
    fontDir.enable = true;
    packages =
      (with pkgs; [
        ibm-plex
        nerd-fonts._0xproto
      ])
      ++ (with inputs.nix-ttf-ms-win11-auto.packages.${pkgs.stdenv.hostPlatform.system}; [
        ttf-ms-win11-auto
        ttf-ms-win11-fod-auto-paneuropean
      ]);
  };

  services.flatpak.enable = true;

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  system.stateVersion = "26.11";

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
      "https://cache.nixos-cuda.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
