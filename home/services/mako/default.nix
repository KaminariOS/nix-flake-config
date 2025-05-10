{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.mako.enable {
    services.mako = {
      enable = true;

      settings = {
        group-by = "app-name";
        default-timeout = 10000;
        actions = true;
        icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus/";
        icons = true;
        border-radius = cfg.theme.borders.radius;
        border-size = 4;
        padding = "15";
        margin = "20,0";
        sort = "+time";
        width = 400;
        height = 300;
        layer = "top";
        anchor = "bottom-right";
        on-notify = "exec ${lib.getExe pkgs.mpv} ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga";
        outer-margin = 20;

        # mode="do-not-disturb";
        invisible = 1;
      };
    };

    systemd.user.services.mako = {
      Unit = {
        After = "graphical-session.target";
        BindsTo = lib.optional (cfg.desktop.sway.enable) "sway-session.target";
        Description = "Lightweight Wayland notification daemon";
        Documentation = "man:mako(1)";
        PartOf = "graphical-session.target";
      };

      Service = {
        BusName = "org.freedesktop.Notifications";
        ExecReload = ''${lib.getExe' pkgs.mako "makoctl"} reload'';
        ExecStart = "${lib.getExe pkgs.mako}";
        Restart = lib.mkForce "no";
        Type = "dbus";
      };

      Install.WantedBy = lib.optional (cfg.desktop.sway.enable) "sway-session.target";
    };
  };
}
