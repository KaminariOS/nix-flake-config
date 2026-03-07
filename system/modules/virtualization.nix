{...}: {
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    oci-containers = {backend = "podman";};
    podman = {
      defaultNetwork.settings.dns_enabled = true;
      enable = true;
      autoPrune.enable = true;
    };
    docker = {
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
