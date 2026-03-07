{
  pkgs,
  full,
  lib,
  config,
  ...
}: let
  inherit (lib) optionals;
  homeDirectory = config.home.homeDirectory;
in {
  imports =
    optionals full [
      ./helix
      ./nushell
      ./gemini
      ./tickrs
      ./sops
    ]
    ++ [
      # ./nvim
      ./starship
      ./zellij
      ./git
      ./fish
      ./neofetch
      ./terminfo.nix
      # ./nix-index.nix
      ./bat
      ./gitui
      # ./jj
      # ./k9s
    ];
  home.file = {
    ".ssh/config".text = ''
      Host *.cloudlab.us
        ForwardAgent yes
        forwardX11Trusted yes
    '';
    ".gdbinit".text = ''
      set auto-load safe-path /
      tui enable
    '';
  };
  home.packages = pkgs.callPackage ../shellEnv/shellList.nix {inherit full;};
  home.sessionVariables = {
    KUBECONFIG = "${homeDirectory}/.kube/config";
  };
  home.sessionPath = [
    "${homeDirectory}/.cargo/bin"
  ];
  programs = {
    kubecolor = {
      enable = true;
      enableAlias = true;
    };
    taskwarrior = {
      package = pkgs.taskwarrior3;
      enable = true;
      dataLocation = "${config.home.homeDirectory}/.task";
      config = {
        confirmation = false;
        report.minimal.filter = "status:pending";
        report.next.filter = "(status:pending or status:waiting)";
      };
    };
    readline = {
      enable = true;
      extraConfig = "set editing-mode vi
          ";
    };
    direnv = {
      enable = true;
      #enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    broot = {
      enable = full;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = ["--height 20%"]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };

    gpg.enable = true;
    ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [];
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      # enableZshIntegration = true;
    };
    navi = {
      enable = full;
      # enableZshIntegration = true;
      enableFishIntegration = true;
    };
    skim = {
      enable = full;
      enableFishIntegration = true;
      # enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      fileWidgetOptions = [
        "--preview 'head {}'"
      ];
    };
    atuin = {
      enable = true;
      enableFishIntegration = true;
      # enableZshIntegration = true;
    };
    tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "yy";
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    gemini-cli = {
      settings.general = {
        "vimMode" = true;
        "preferredEditor" = "nvim";
      };
    };
  };
}
