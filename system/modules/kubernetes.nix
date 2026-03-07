{...}: {
  networking.firewall = {
    enable = true;
    allowPing = false;
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
}
