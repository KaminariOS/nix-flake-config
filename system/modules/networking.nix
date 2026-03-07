{pkgs, ...}: {
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
      plugins = [pkgs.networkmanager-openvpn];
    };
    useDHCP = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [fcitx5-rime qt6Packages.fcitx5-chinese-addons fcitx5-mozc];
  };

  time.timeZone = "America/New_York";

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.conf.all.forwarding" = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];
}
