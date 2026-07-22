{
  config,
  lib,
  pkgs,
  ...
}: let
  mod = "Mod4";
in {
  xsession = {
    initExtra = ''
    '';

    profileExtra = ''
      #eval $(${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=ssh,secrets)
      #export SSH_AUTH_SOCK

      # Disable screensaver
      xset s off
      xset s noblank
      xset -dpms
    '';
    windowManager.i3 = {
      # enable = true;
      package = pkgs.i3;
      extraConfig = builtins.readFile ./config;
      config = {
        modifier = mod;

        window.border = 0;

        gaps = {
          inner = 10;
          outer = 3;
          smartBorders = "on";
          smartGaps = true;
        };

        assigns = {
          "1" = [{class = "wezterm";}];
        };

        defaultWorkspace = "workspace number 9";

        terminal = "wezterm";

        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
          "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
          #"${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
          # "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
          #        "${mod}+Shift+x" = "exec i3lock-fancy-dualmonitor";
          "${mod}+Shift+x" = "exec loginctl lock-session";
          "${mod}+Return" = "exec wezterm; workspace1";
          "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -modes drun -show drun";
          "${mod}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -modes window -show window";
          # Focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          #     "${mod}+1" = "workspace Terminal";

          # My multi monitor setup
          "${mod}+m" = "move workspace to output DP-2";
          "${mod}+Shift+m" = "move workspace to output DP-5";

          "${mod}+Tab" = "fullscreen toggle , focus right, fullscreen toggle";
          "${mod}+Shift+Tab" = "fullscreen toggle , focus left, fullscreen toggle";
        };

        bars = [
        ];

        startup = [
          {
            command = "i3-msg 'workspace 1; exec wezterm'";
            always = true;
            notification = false;
          }
          {
            command = "i3-msg 'workspace 2; exec firefox'";
            always = true;
            notification = false;
          }
          {
            command = "exec --no-startup-id picom -CGb";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart polybar.service";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart imec.service";
            always = true;
            notification = false;
          }
          {
            command = ''${config.home.homeDirectory}/.nix-profile/bin/feh --bg-scale ~/Pictures/wallpaper.jpg'';
            always = true;
            notification = false;
          }
        ];
      };
    };
  };
}
