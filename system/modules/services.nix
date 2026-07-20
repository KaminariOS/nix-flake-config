{pkgs, ...}: {
  services = {
    acpid.enable = true;
    upower.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";
    gvfs.enable = true;
    tailscale.enable = true;
    v2raya.enable = true;

    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "true";
        Domains = ["~."];
        FallbackDNS = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        DNSOverTLS = "true";
      };
    };

    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    sshd.enable = true;

    printing = {
      enable = true;
      drivers = [pkgs.epson-escpr];
    };

    postgresql.enable = false;
  };
}
