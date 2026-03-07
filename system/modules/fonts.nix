{pkgs, ...}: let
  myfonts = pkgs.callPackage ../fonts/default.nix {inherit pkgs;};
in {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-color-emoji
      ubuntu-classic
      jetbrains-mono
      font-awesome
      myfonts.flags-world-color
      myfonts.icomoon-feather
      noto-fonts-color-emoji
      nerd-fonts.iosevka
      sarasa-gothic
      fira-code
      fira-code-symbols
      unifont
      ipafont
      arphic-ukai
      noto-fonts-lgc-plus
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto fonts" "AR PL UKai HK" "Sarasa Gothic" "Ubuntu"];
      sansSerif = ["Noto Serif" "AR PL UKai HK" "Sarasa Gothic" "IPAPGothic" "Ubuntu"];
      monospace = ["AR PL UKai HK" "fira-code" "Sarasa Gothic" "font-awesome"];
      emoji = ["Noto Emoji Color"];
    };
  };
}
