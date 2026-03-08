{
  config,
  lib,
  pkgs,
  ...
}: {
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

  systemd.services.virt-secret-init-encryption = {
    description = "Initialize libvirt secret encryption key";
    before = ["virtsecretd.service" "libvirtd.service"];
    startLimitBurst = 3;
    startLimitIntervalSec = 30;
    unitConfig.ConditionPathExists = "!/var/lib/libvirt/secrets/secrets-encryption-key";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.mkForce [
        ""
        "${pkgs.runtimeShell} -c 'umask 0077 && (${lib.getExe' pkgs.coreutils "dd"} if=/dev/random status=none bs=32 count=1 | ${config.systemd.package}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
      ];
    };
  };
}
