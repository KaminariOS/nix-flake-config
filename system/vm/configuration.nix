{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
} @ args: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = true;
    # Optionally, enable for IPv4 as well
    "net.ipv4.conf.all.forwarding" = true;
  };
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    firewall = {
      # List services that you want to enable:

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      enable = true;
      allowPing = false;
      trustedInterfaces = ["cni+" "flannel.1" "calico+" "cilium+" "lxc+"];
      allowedTCPPorts = [
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
        10250 # Kubelet
        2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
        22 # ssh
        80 # http
        443 # https
        8080
        8443 # nginx
      ];
      allowedUDPPorts = [
        8443 # nginx
        8472 # k3s, flannel: required if using multi-node for inter-node networking
        53 # k3s DNS
      ];
    };
    hostName = "oracle";
  }; # Define your hostname.
  environment.systemPackages = map lib.lowPrio (with pkgs; [
    curl
    gitMinimal
    neovim
  ]);
  programs.fish.enable = true;
  virtualisation = {
    oci-containers = {backend = "podman";};
    podman = {
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      enable = true;
      autoPrune.enable = true;
    };
    docker = {
      # enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  services = {
    tailscale.enable = true;
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
    k3s = {
      role = "server";
      # serverAddr = "https://100.124.90.107:6443";
      tokenFile = "/etc/k3s.token";
      extraFlags = [
        "--disable=traefik"
        "--disable=servicelb"
        "--write-kubeconfig-mode=644"
        "--secrets-encryption"
        "--etcd-expose-metrics=false"
        "--node-ip=100.82.130.68"
        "--advertise-address=100.82.130.68"
        "--tls-san=100.82.130.68"
        "--flannel-backend=wireguard-native"
      ];

      enable = true;
    };
  };

  security = {
    # lets users use sudo without password
    sudo.wheelNeedsPassword = false;
  };
  users.users.kosumi = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["docker" "networkmanager" "wheel" "scanner" "lp" "video" "input" "qemu-libvirtd" "kvm"]; # wheel for ‘sudo’.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrWwGk9L6aGeJUflLOY25e7Aaa/AfDU51irnmchw1Zw thinker@example.com"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys =
    [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrWwGk9L6aGeJUflLOY25e7Aaa/AfDU51irnmchw1Zw thinker@example.com"
    ]
    ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  time.timeZone = "America/New_York";
  system.stateVersion = "24.05";

  # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nixPath = ["nixpkgs=${pkgs.path}"];

    # Flakes settings
    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = ["root" "kosumi"];

      experimental-features = ["nix-command" "flakes"];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };
}
