{pkgs, ...}: {
  environment.systemPackages = let
    themes = pkgs.callPackage ../sddm-theme.nix {};
  in
    (with pkgs; [
      firejail
      neovim
      wget
      home-manager
    ])
    ++ (with pkgs.qt5; [qtgraphicaleffects qtsvg qtquickcontrols])
    ++ [themes.sddm-sugar-candy];

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese
      gnome-music
      gnome-terminal
      gedit
      epiphany
      geary
      evince
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
    ]);

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };
    appimage.enable = true;
    appimage.binfmt = true;

    virt-manager.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld.enable = true;

    fish.enable = true;
    fuse.userAllowOther = true;
    partition-manager.enable = true;
    sway.enable = true;
    sway.xwayland.enable = true;
    xwayland.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    ssh.extraConfig = ''
      Host *.cloudlab.us
        ForwardAgent yes
    '';
  };
}
