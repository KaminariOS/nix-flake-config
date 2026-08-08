{...}: {
  imports = [
    ./cachix.nix
    ./modules/networking.nix
    ./modules/programs.nix
    ./modules/virtualization.nix
    ./modules/desktop.nix
    ./modules/services.nix
    ./modules/kubernetes.nix
    ./modules/fonts.nix
    ./modules/users.nix
    ./modules/security.nix
    ./modules/nix.nix
  ];
}
