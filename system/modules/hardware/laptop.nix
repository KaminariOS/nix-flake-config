{
  imports = [./base.nix];

  hardware = {
    acpilight.enable = true;
    bluetooth.enable = true;
  };

  boot.kernelParams = ["acpi_backlight=native"];
}
