# nix-index setup with pre-built indices
{
  pkgs,
  lib,
  full,
  ...
}: let
  # https://github.com/Mic92/nix-index-database
  updateScript = pkgs.writeShellScriptBin "update-nix-index" ''
    set -euo pipefail
    export PATH="${lib.makeBinPath [pkgs.coreutils pkgs.wget]}"

    finish() {
      ret=$?

      if [[ "$ret" == "0" ]]; then
        >&2 echo "Update successful!"
      else
        >&2 echo "Update failed"
      fi

      exit $ret
    }

    trap finish EXIT

    >&2 echo "Updating nix-index..."

    filename="index-x86_64-$(uname | tr A-Z a-z)"
    mkdir -p ~/.cache/nix-index
    cd ~/.cache/nix-index
    # -N will only download a new version if there is an update.
    wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
    ln -f $filename files
  '';
in {
  home.packages = [updateScript];

  programs.nix-index = {
    # enable = full;
    # enableFishIntegration = true;
  };
}
