{
  description = "Home Manager configuration of Kosumi";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nurpkgs.url = "github:nix-community/NUR";

    # for macos
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homeage = {
      url = "github:jordanisaacs/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    # nixpkgs-nautilus-gtk3.url = "github:NixOS/nixpkgs?ref=37bd398";

    # plasma-manager.url = "github:pjones/plasma-manager";
    # plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    # plasma-manager.inputs.home-manager.follows = "home-manager";

    # rycee-nurpkgs = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    neovim-flake = {
      # url = "github:notashelf/neovim-flake";
      url = "github:KaminariOS/neovim-flake/master";
      # neovim-flake pushes its binaries to the cache using its own nixpkgs version
      # if we instead use ours, we'd be rebuilding all plugins from scratch
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fish shell

    fish-bobthefish-theme = {
      url = "github:gvolpe/theme-bobthefish";
      flake = false;
    };

    fish-keytool-completions = {
      url = "github:ckipp01/keytool-fish-completions";
      flake = false;
    };

    # Github Markdown ToC generator

    gh-md-toc = {
      url = "github:ekalinin/github-markdown-toc";
      flake = false;
    };

    # LaTeX stuff

    tex2nix = {
      #url = github:Mic92/tex2nix;
      url = "github:gvolpe/tex2nix"; # fork with nixFlakes fix
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };
  };

  outputs = inputs: let
    forDefaultSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forLinuxSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllHosts = inputs.nixpkgs.lib.genAttrs [
      "savior"
      "portable"
      "redmoon"
    ];
  in {
    formatter = forDefaultSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
    packages = forDefaultSystems (system: {
      homeConfigurations = import ./outputs/home-conf.nix {
        inherit inputs system;
      };

      nixosConfigurations = import ./outputs/nixos-conf.nix {
        inherit inputs system;
      };
    });
  };
}
