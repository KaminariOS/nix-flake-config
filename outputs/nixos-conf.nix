{
  inputs,
  system,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  defaultSystem = system;

  # Modules applied to every host
  commonModules = [
    ../system/modules/auto-upgrade.nix
    ../system/modules/bbr.nix
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.nix-index
    {programs.nix-index-database.comma.enable = true;}
  ];

  # Helper function to define a NixOS host
  mkHost = {
    name,
    enableDisplayLink ? true,
  }:
    nixosSystem {
      system = defaultSystem;
      specialArgs = {inherit enableDisplayLink inputs;};
      modules =
        [
          ../system/machine/${name}
          ../system/configuration.nix
        ]
        ++ commonModules;
    };
  mkCustomHost = {
    system,
    modules,
  }:
    nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = modules ++ commonModules;
    };
in {
  oracle = mkCustomHost {
    system = "aarch64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      ../system/vm/configuration.nix
      ../system/vm/hardware-configuration.nix
    ];
  };
  savior = mkHost {name = "savior";};
  thinker = mkHost {name = "thinker";};
  thinkery = mkHost {name = "thinkery";};

  # DisplayLink's source requires accepting an EULA and manually adding it to
  # the Nix store. Keep it on the real hosts, but omit it from clean CI builds.
  savior-ci = mkHost {
    name = "savior";
    enableDisplayLink = false;
  };
  thinker-ci = mkHost {
    name = "thinker";
    enableDisplayLink = false;
  };
}
