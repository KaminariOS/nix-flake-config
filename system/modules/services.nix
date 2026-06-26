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

    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
        CREATE DATABASE nixcloud;
        GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
      '';
    };
  };
}
