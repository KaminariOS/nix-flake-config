# Edit this configuration file to define what should be installed on
# your system.  Help is available in the default.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot = {
    loader = {
      # Bootloader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    # kernelModules = ["nouveau"];
    # kernelParams = [
    #   "nvidia-drm.fbdev=1"
    # ];
  };

  networking.hostName = "savior"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation = {
    # virtualbox.host = {
    #   enable = true;
    #   enableExtensionPack = true;
    # };
  };
  hardware = {
    nvidia = {
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = false;
      open = !true;
    };
    graphics = {
      enable = true;
      # extraPackages = with pkgs; [mesa mesa.drivers];
    };
  };
  services = {
    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.utf8";

    k3s.extraFlags = toString [
      "--tls-san"
      "100.124.90.107"
      # "--debug" # Optionally add additional args to k3s
    ];
    xserver.videoDrivers = ["nvidia"];

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      wireplumber.enable = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kosumi = {
    isNormalUser = true;
    description = "kosumi";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["cuda_cccl" "cuda_cudart" "cuda_nvcc" "libcublas" "nvidia-settings" "nvidia-x11"];
    nvidia.acceptLicense = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit default.nix! The Nano editor is also installed by default.
    #  wget
  ];

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
  system.stateVersion = "22.05"; # Did you read the comment?
}
