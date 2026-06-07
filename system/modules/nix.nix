{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nixPath = ["nixpkgs=${pkgs.path}"];
    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "kosumi"];
      experimental-features = ["nix-command" "flakes"];
      extra-substituters = ["https://fcitx5-vinput.cachix.org"];
      extra-trusted-public-keys = ["fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="];
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  system.stateVersion = "22.05";
}
