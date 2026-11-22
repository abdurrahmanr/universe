{
  description = "abdurrahmanr's NixOS configs";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nix-ttf-ms-win11-auto.url = "github:kugland/nix-ttf-ms-win11-auto";

    NixVirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel.url = "github:noctalia-dev/umbriel/cachix";
    luciole.url = "github:noctalia-dev/luciole/cachix";

    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      neovim-nightly-overlay,
      nix-flatpak,
      disko,
      agenix,
      NixVirt,
      nix-ttf-ms-win11-auto,
      ...
    }@inputs:
    {
      nixosConfigurations.nidaime = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/nidaime/configuration.nix
          agenix.nixosModules.default
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.abdurrahmanr = import ./home/default.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
