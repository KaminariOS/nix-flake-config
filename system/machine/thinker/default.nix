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
    ./hardware-configuration.nix
  ];
  boot = {
    loader = {
      # Bootloader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    blacklistedKernelModules = ["ideapad_laptop"];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["amdgpu"];
  };

  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [mesa mesa.drivers];
  # };

  networking.hostName = "thinker"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services = {
    k3s.role = "server";
    # Set your time zone.
    # time.timeZone = "America/Denver";

    # Select internationalisation properties.
    #  i18n.defaultLocale = "en_US.utf8";

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

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
  users.users.kosumi = {
    isNormalUser = true;
    description = "kosumi";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit default.nix! The Nano editor is also installed by default.
    #  wget
  ];

  virtualisation = {
    virtualbox.host = {
      enable = false;
      enableExtensionPack = false;
    };
  };

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
