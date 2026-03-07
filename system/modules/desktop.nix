{pkgs, ...}: {
  environment.etc."greetd/environments".text = ''
    sway
  '';

  services = {
    pipewire.wireplumber.enable = true;
    auto-cpufreq.enable = true;
    xserver = {
      videoDrivers = ["displaylink" "modesetting"];
      desktopManager.runXdgAutostartIfNone = true;

      displayManager.session = [
        {
          manage = "desktop";
          name = "none+sway";
          start = "sway";
        }
      ];
    };

    greetd = {
      enable = true;
      settings.default_session.command = ''
        ${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd "sway --unsupported-gpu"
      '';
    };

    displayManager.sddm = {
      wayland.enable = true;
      enableHidpi = true;
      theme = "sugar-candy";
    };

    blueman.enable = true;
    pcscd.enable = true;
  };
}
