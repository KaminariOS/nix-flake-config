self: super: {
  # obs-studio = super.obs-studio.overrideAttrs (oldAttrs: {
  #   # extend old postInstall (if exists) with wrapProgram
  #   postInstall =
  #     (oldAttrs.postInstall or "")
  #     + ''
  #       wrapProgram $out/bin/obs --set QT_QPA_PLATFORM wayland
  #     '';
  # });

  okular = super.okular.overrideAttrs (oldAttrs: {
    # extend old postInstall (if exists) with wrapProgram
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        wrapProgram $out/bin/okular --set QT_SCALE_FACTOR 2
      '';
  });

  # telegram-desktop = super.telegram-desktop.overrideAttrs (oldAttrs: {
  #   # extend old postInstall (if exists) with wrapProgram
  #   postInstall =
  #     (oldAttrs.postInstall or "")
  #     + ''
  #       wrapProgram $out/bin/telegram-desktop --set QT_SCALE_FACTOR 2
  #     '';
  # });
  # wireshark = super.wireshark.overrideAttrs (oldAttrs: {
  #   # extend old postInstall (if exists) with wrapProgram
  #   postInstall =
  #     (oldAttrs.postInstall or "")
  #     + ''
  #       wrapProgram $out/bin/wireshark --set QT_SCALE_FACTOR 2
  #     '';
  # });

  # dolphin

  # jetbrains.clion = super.jetbrains.clion.overrideAttrs (oldAttrs: {
  #   # extend old postInstall (if exists) with wrapProgram
  #   postInstall =
  #     (oldAttrs.postInstall or "")
  #     + ''
  #       wrapProgram $out/bin/clion --set GDK_SCALE 2
  #     '';
  # });
  #
  # jetbrains.idea-ultimate = super.jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
  #   # extend old postInstall (if exists) with wrapProgram
  #   postInstall =
  #     (oldAttrs.postInstall or "")
  #     + ''
  #       wrapProgram $out/bin/idea-ultimate --set GDK_SCALE 2
  #     '';
  # });
}
