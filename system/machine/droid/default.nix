# Edit this configuration file to define what should be installed on
# your system.  Help is available in the default.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    <nixos-avf/avf>
    # ./hardware-configuration.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [mesa mesa.drivers];
  # };

  networking.hostName = "droid"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  environment.systemPackages = with pkgs; [
    neovim
    wget
    home-manager
  ];

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld.enable = true;

    fish.enable = true;
    # fuse.userAllowOther = true;
    # partition-manager.enable = true;
    # sway.enable = true;
    # sway.xwayland.enable = true;
    # xwayland.enable = true;
    # dconf.enable = true;
    # nm-applet.enable = true;
    ssh.extraConfig = ''
      Host *.cloudlab.us
        ForwardAgent yes
    '';
  };

  virtualisation = {
    # libvirtd.enable = true;
    # spiceUSBRedirection.enable = true;
    oci-containers = {backend = "podman";};
    podman = {
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # enable = true;
      autoPrune.enable = true;
    };
    # docker = {
    #   # enable = true;
    #   autoPrune = {
    #     enable = true;
    #     dates = "weekly";
    #   };
    # };
  };
  # Enable networking
  # networking.networkmanager.enable = true;
  services = {
    tailscale.enable = true;

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no"; # disable root login
        PasswordAuthentication = false; # disable password login
      };
    };

    # SSH daemon.
    sshd.enable = true;

    # k3s = let
    #   nodeip = "=100.89.217.50";
    # in {
    #   role = "server";
    #   # serverAddr = "https://100.124.90.107:6443";
    #   tokenFile = "/etc/k3s.token";
    #   extraFlags = [
    #     "--disable=traefik"
    #     "--disable=servicelb"
    #     "--write-kubeconfig-mode=644"
    #     "--secrets-encryption"
    #     "--etcd-expose-metrics=false"
    #     ("--node-ip" + nodeip)
    #     ("--advertise-address" + nodeip)
    #     ("--tls-san" + nodeip)
    #     "--flannel-backend=wireguard-native"
    #   ];
    # };
    # Set your time zone.
    # time.timeZone = "America/Denver";

    # Select internationalisation properties.
    #  i18n.defaultLocale = "en_US.utf8";

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable sound with pipewire.
    # pipewire = {
    #   enable = true;
    #   alsa.enable = true;
    #   alsa.support32Bit = true;
    #   pulse.enable = true;
    #   # If you want to use JACK applications, uncomment this
    #   #jack.enable = true;
    #
    #   # use the example session manager (no others are packaged yet so this is enabled by default,
    #   # no need to redefine it in your config for now)
    #   #media-session.enable = true;
    # };

    # fprintd = {
    #   enable = true;
    #   package = pkgs.fprintd-tod;
    #   tod = {
    #     enable = true;
    #     driver = pkgs.libfprint-2-tod1-vfs0090;
    #   };
    # };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # services.xserver.videoDrivers = [ "amdgpu" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraGroups.vboxusers.members = ["kosumi"];
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.kosumi = {
      isNormalUser = true;
      extraGroups = ["docker" "networkmanager" "wheel" "scanner" "lp" "video" "input" "qemu-libvirtd" "kvm"]; # wheel for ‘sudo’.
      shell = pkgs.fish;
      openssh.authorizedKeys.keyFiles = [];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrWwGk9L6aGeJUflLOY25e7Aaa/AfDU51irnmchw1Zw thinker@example.com
"];
    };
    groups.libvirtd.members = ["kosumi"];
    users.root = {
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #  vim # Do not forget to add an editor to edit default.nix! The Nano editor is also installed by default.
  #  wget

  # virtualisation = {
  #   virtualbox.host = {
  #     enable = false;
  #     enableExtensionPack = false;
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man default.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
