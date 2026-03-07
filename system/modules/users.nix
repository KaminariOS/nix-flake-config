{pkgs, ...}: {
  users = {
    extraGroups.vboxusers.members = ["kosumi"];
    users.kosumi = {
      isNormalUser = true;
      extraGroups = ["docker" "networkmanager" "wheel" "scanner" "lp" "video" "input" "qemu-libvirtd" "kvm"];
      shell = pkgs.fish;
      openssh.authorizedKeys.keyFiles = [];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrWwGk9L6aGeJUflLOY25e7Aaa/AfDU51irnmchw1Zw thinker@example.com
"];
    };
    groups.libvirtd.members = ["kosumi"];
    users.root = {};
  };
}
