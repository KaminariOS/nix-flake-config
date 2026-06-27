{
  config,
  lib,
  pkgs,
  ...
}: let
  usesTailscaleFlannel =
    config.services.k3s.enable
    && lib.any (flag: lib.hasPrefix "--flannel-iface=tailscale0" flag) config.services.k3s.extraFlags;
in {
  networking.firewall = {
    enable = true;
    allowPing = false;
    checkReversePath = lib.mkIf usesTailscaleFlannel false;
    trustedInterfaces = ["cni+" "flannel.1" "calico+" "cilium+" "lxc+"];
    allowedTCPPorts = [
      6443
      2379
      10250
      2380
      22
      8081
      8765
    ];
    allowedUDPPorts = [
      8472
      53
    ];
  };

  services.k3s.extraFlags = [];

  boot.kernel.sysctl = lib.mkIf usesTailscaleFlannel {
    "net.ipv4.conf.all.src_valid_mark" = true;
  };

  systemd.services.k3s = lib.mkIf usesTailscaleFlannel {
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
    preStart = lib.mkBefore ''
      ready=0
      i=0
      while [ "$i" -lt 30 ]; do
        if ${pkgs.iproute2}/bin/ip link show tailscale0 >/dev/null 2>&1; then
          ready=1
          break
        fi
        i=$((i + 1))
        ${pkgs.coreutils}/bin/sleep 2
      done

      if [ "$ready" -ne 1 ]; then
        echo "tailscale0 did not appear before k3s start" >&2
        exit 1
      fi
    '';
  };
}
