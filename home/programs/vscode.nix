{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions;
          [
            vscodevim.vim
            eamodio.gitlens
            pkief.material-icon-theme
            ms-vscode-remote.remote-ssh
            christian-kohler.path-intellisense
            oderwat.indent-rainbow

            sdras.night-owl
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # {
            #   name = "verus-analyzer";
            #   publisher = "verus-lang";
            #   version = "0.3.231";
            #   sha256 = "sha256-dIwv/pQ4R2lcYdzlMq/tKWWeHQHbdATLlfY5DKUbKVI=";
            # }
          ];
        keybindings = [
          {
            key = "shift+k";
            command = "editor.action.showHover";
            when = "editorTextFocus";
          }
        ];
        userSettings = {
          "files.autoSave" = "onFocusChange";
          "workbench.colorTheme" = lib.mkForce "Night Owl";
          "vim.useSystemClipboard" = true;
        };
      };
    };
  };
}
