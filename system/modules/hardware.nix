{pkgs, ...}: {
  hardware = {
    acpilight.enable = true;
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
    };
    graphics.enable32Bit = true;
    graphics.enable = true;
    bluetooth.enable = true;
  };

  boot.kernelParams = [
    ''GRUB_CMDLINE_LINUX_DEFAULT="quiet udev.log_priority=3 acpi_backlight=native"''
    "amd_iommu"
  ];
}
