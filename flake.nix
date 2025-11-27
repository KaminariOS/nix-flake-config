{
  description = "Home Manager configuration of Kosumi";
  inputs = {
    # colmena.url = "github:zhaofengli/colmena";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    code.url = "github:just-every/code";
    # optional, but helps keep nixpkgs versions aligned
    code.inputs.nixpkgs.follows = "nixpkgs";
    nurpkgs.url = "github:nix-community/NUR";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # for macos
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nix-darwin = {
    #   url = "github:lnl7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs-darwin";
    # };

    # NixOS profiles to optimize settings for different hardware.
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:yaxitech/ragenix";
    # };

    #Declarative disk partitioning and formatting using nix
    # disko = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:nix-community/disko";
    # };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # haumea = {
    #   url = "github:nix-community/haumea/v0.2.2";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # rycee-nurpkgs = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # neovim-flake = {
    #   # url = "github:notashelf/neovim-flake";
    #   url = "github:KaminariOS/neovim-flake/master";
    #   # neovim-flake pushes its binaries to the cache using its own nixpkgs version
    #   # if we instead use ours, we'd be rebuilding all plugins from scratch
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
    sops-nix,
    ...
  } @ inputs: let
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

    checks = forDefaultSystems (
      system: {
        # eval-tests per system
        # eval-tests = allSystems.${system}.evalTests == {};

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ".";
          hooks = {
            alejandra.enable = true; # formatter
            # Source code spell checker
            typos = {
              enable = !true;
              settings = {
                write = true; # Automatically fix typos
                configPath = "./.typos.toml"; # relative to the flake root
              };
            };
            prettier = {
              enable = false;
              settings = {
                write = true; # Automatically format files
                configPath = "./.prettierrc.yaml"; # relative to the flake root
              };
            };
            # deadnix.enable = true; # detect unused variable bindings in `*.nix`
            # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
          };
        };
      }
    );

    # Development Shells
    devShells = forDefaultSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
            bashInteractive
            # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
            gcc
            # Nix-related
            alejandra
            deadnix
            statix
            # spell checker
            typos
            # code formatter
            # nodePackages.prettier
          ];
          name = "dots";
          shellHook = ''
            ${self.checks.${system}.pre-commit-check.shellHook}
          '';
        };
      }
    );
  };
}
