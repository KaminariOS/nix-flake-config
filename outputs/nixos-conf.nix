{
  inputs,
  system,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  # Helper function to define a NixOS host
  mkHost = name:
    nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ../system/machine/${name}
        ../system/configuration.nix
        inputs.sops-nix.nixosModules.sops
      ];
    };
in {
  savior = mkHost "savior";
  portable = mkHost "portable";
  redmoon = mkHost "redmoon";
  thinker = mkHost "thinker";
}
