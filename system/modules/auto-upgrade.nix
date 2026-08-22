{config, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:KaminariOS/nix-flake-config/dev#${config.networking.hostName}";
    dates = "daily";
    randomizedDelaySec = "1h";
    persistent = true;
    allowReboot = false;
  };
}
