{
  config,
  pkgs,
  lib,
  stdenv,
  specialArgs,
  ...
}: let
  shellPkgs = pkgs.callPackage ../shellEnv/shellList.nix {inherit specialArgs;};
in {
  imports = builtins.concatMap import [
    #      ./age
    ../shellEnv
    #      ./themes
  ];
  home = {
    stateVersion = "22.05";
    #    packages = defaultPkgs ++ gnomePkgs;
    packages = shellPkgs;
    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "nvim";
      TERM_PROGRAM = "WezTerm";
    };
  };

  # notifications about home-manager news
  news.display = "silent";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
