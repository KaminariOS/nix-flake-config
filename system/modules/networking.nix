{
  inputs,
  lib,
  pkgs,
  ...
}: let
  fcitx5-vinput = inputs.fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  networking = {
    networkmanager = {
      dns = "systemd-resolved";
      enable = true;
      plugins = [pkgs.networkmanager-openvpn];
    };
    useDHCP = false;
    firewall.interfaces.tailscale0.allowedTCPPorts = [4096];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      qt6Packages.fcitx5-chinese-addons
      fcitx5-mozc
      fcitx5-vinput
    ];
  };

  environment.systemPackages = [
    fcitx5-vinput
  ];

  systemd.user.services.vinput-daemon = {
    description = "Vinput Voice Input Daemon";
    after = ["pipewire.service"];
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.fcitx.Vinput";
      ExecStart = lib.getExe' fcitx5-vinput "vinput-daemon";
    };
  };

  time.timeZone = "America/New_York";

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.all.disable_ipv6" = false;
    "net.ipv6.conf.default.disable_ipv6" = false;
    "net.ipv6.conf.tailscale0.disable_ipv6" = false;
    "net.ipv4.conf.all.forwarding" = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];
}
