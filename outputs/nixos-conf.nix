{
  inputs,
  system,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  defaultSystem = system;

  # Helper function to define a NixOS host
  mkHost = name:
    nixosSystem {
      system = defaultSystem;
      specialArgs = {inherit inputs;};
      modules = [
        ../system/machine/${name}
        ../system/configuration.nix
        inputs.sops-nix.nixosModules.sops
        inputs.nix-index-database.nixosModules.nix-index
        {programs.nix-index-database.comma.enable = true;}
      ];
    };
  mkCustomHost = {
    system,
    modules,
  }:
    nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules =
        modules
        ++ [
          inputs.sops-nix.nixosModules.sops
          inputs.nix-index-database.nixosModules.nix-index
          {programs.nix-index-database.comma.enable = true;}
        ];
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
  savior = mkHost "savior";
  thinker = mkHost "thinker";
  thinker-242 = mkHost "thinker-242";
}
