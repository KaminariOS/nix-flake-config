{
  inputs,
  system,
  ...
}:
with inputs; let
  fishOverlay = f: p: {
    inherit fish-bobthefish-theme;
  };
  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config = {
      packageOverrides = pkgs: {
        espanso = pkgs.espanso.override {
          x11Support = false;
          waylandSupport = true;
        };
      };
    };

    overlays = [
      fishOverlay
      nurpkgs.overlays.default
      # (import ../overlay.nix)
      nurpkgs.overlays.default
      #neovim-flake.overlays.${system}.default
      (f: p: {tex2nix = tex2nix.defaultPackage.${system};})
      ((import ../home/overlays/md-toc) {inherit (inputs) gh-md-toc;})
      (import ../home/overlays/ranger)
    ];
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };
  commonImports = [
    # inputs.sops-nix.homeManagerModules.sops
    # neovim-flake.homeManagerModules.default
  ];

  mkHome = {
    hidpi ? false,
    username,
    gui ? false,
    full ? true,
    homed,
  }: (
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit hidpi;
        inherit full;
        inherit gui;
        addons = nur.repos.rycee.firefox-addons;
      };

      modules = let
        homeDirectory = homed;
      in [
        {
          imports =
            commonImports
            ++ [../home/home.nix]
            ++ pkgs.lib.optional gui inputs.stylix.homeModules.stylix;
        }
        {
          home = {
            inherit username;
            inherit homeDirectory;
          };
          programs.git.signing.signByDefault = gui;
          xdg = {
            configHome = "${homeDirectory}/.config";
            enable = true;
          };
        }
      ];
    }
  );
in {
  kosumi = let
    username = "kosumi";
  in
    mkHome {
      hidpi = false;
      gui = true;
      full = true;
      inherit username;
      homed = "/home/${username}";
    };

  shellhome = let
    username = "kosumic";
  in
    mkHome {
      hidpi = false;
      inherit username;
      gui = false;
      full = false;
      homed = "/users/${username}";
    };
  droid = let
    username = "droid";
  in
    mkHome {
      hidpi = false;
      inherit username;
      gui = false;
      full = false;
      homed = "/home/${username}";
    };
  shellhomeForWork = let
    username = "kchen";
  in
    mkHome {
      hidpi = false;
      inherit username;
      gui = false;
      full = false;
      homed = "/home/${username}";
    };
  cloud = let
    username = "kosumi";
  in
    mkHome {
      hidpi = false;
      inherit username;
      gui = false;
      full = false;
      homed = "/home/${username}";
    };
  # Continuous Integration automation
  #  ci = {
  #    metals = pkgs.callPackage ../home/programs/neovim-ide/metals.nix { };
  #    metals-updater = pkgs.callPackage ../home/programs/neovim-ide/update-metals.nix { };
  #  };
}
