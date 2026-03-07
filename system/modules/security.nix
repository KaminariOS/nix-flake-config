{lib, ...}: {
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
    };
    lsm = lib.mkForce [];
    pam.yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
    };
    pam.services = {
      swaylock.fprintAuth = true;
      login.enableGnomeKeyring = true;
    };
    sudo.configFile = ''
      Defaults lecture=always
      Defaults lecture_file=${../misc/groot.txt}
    '';
    sudo.wheelNeedsPassword = false;
  };
}
