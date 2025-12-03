- sops-nix
- yubikey
- kubenix
- colmena
- deploy-rs
- Fix randomWallpaper fork bug
- https://github.com/niki-on-github/nixos-k3s
- https://github.com/stepbrobd/dotfiles/blob/master/flake.nix

  - outputs/home-conf.nix:7-135 – The overlay stack repeats nurpkgs.overlays.default, and fishOverlay ignores the upstream package set. Converting these to proper overlays (final: prev: { … }) and building the home
    configurations with lib.genAttrs over a data table would remove duplication and make it trivial to add or tweak users.
  - system/machine/*/default.nix – Each host redefines the same user, printing, pipewire, and VirtualBox stanzas. Extract those into a shared module (e.g. system/machine/common.nix) and keep the host files focused on deltas
    like boot settings or k3s flags. This will shrink the per-host files dramatically and prevent drift.
  - system/configuration.nix:20-225 – The monolithic module mixes networking, audio, virtualization, display management, and firewall logic. Splitting these into topical modules (e.g. modules/networking.nix, modules/
    virtualization.nix, modules/desktop.nix) keeps evaluations faster and makes it easier to reason about option precedence.
  - system/machine/thinker/default.nix:41-55 – Building k3s flags by concatenating strings with a leading “=” is brittle. Generate them with lib.concatStringsSep or lib.cli.toGNUCommandLine, or switch to the structured
    services.k3s.serverArgs options to avoid hand-maintaining flag syntax.
  - home/home.nix:24-133 and home/gui.nix:6-62 – You’re manually joining multiple package lists and even list brightnessctl twice; wrap these lists in lib.concatLists and apply lib.unique (or split them into categorized
    attrsets) so overlays/package additions don’t introduce duplicates. While you’re there, replace builtins.concatMap import with a simple map import + lib.optional chain to make the intent clearer.

- starship hostname
