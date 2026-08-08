{
  config,
  pkgs,
  ...
}: {
  programs.jujutsu = {
    enable = true;
  };
  programs.jjui.enable = true;
}
