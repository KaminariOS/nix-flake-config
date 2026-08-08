{pkgs, ...}: {
  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  boot.kernelParams = [
    "quiet"
    "udev.log_priority=3"
  ];
}
