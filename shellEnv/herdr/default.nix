{herdr, ...}: {
  home.packages = [herdr];

  xdg.configFile."herdr/config.toml".text = ''
    [keys]
    prefix = "ctrl+a"

    [theme]
    name = "tokyo-night"

    [ui]
    agent_panel_sort = "priority"

    [ui.toast]
    delivery = "system"
  '';
}
