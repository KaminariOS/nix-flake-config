{
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.wezterm}/bin/wezterm";
    theme = lib.mkForce ./launcher/type2-style-10.rasi;
  };
}
