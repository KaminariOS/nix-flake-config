{
  inputs,
  lib,
  pkgs,
  ...
}: {
  disabledModules = [
    ../thinker/hardware-configuration.nix
  ];

  imports = [
    inputs.disko.nixosModules.disko
    ../thinker
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot = {
    supportedFilesystems = ["zfs"];
    zfs.forceImportRoot = false;
  };

  networking.hostName = lib.mkForce "thinkery";
  networking.hostId = "de6fdbd1";
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "tailscale-udp-gro-enp0s31f6" ''
        if [ "$DEVICE_IFACE" != "enp0s31f6" ]; then
          exit 0
        fi

        if [ "$2" != "up" ] && [ "$2" != "dhcp4-change" ] && [ "$2" != "connectivity-change" ]; then
          exit 0
        fi

        ${pkgs.ethtool}/bin/ethtool -K "$DEVICE_IFACE" rx-udp-gro-forwarding on rx-gro-list off
      '';
      type = "basic";
    }
  ];
  services.xserver.videoDrivers = lib.mkForce ["modesetting"];
}
