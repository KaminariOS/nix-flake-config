{
  config,
  pkgs,
  ...
}: let
  gitConfig = {
    core = {
      editor = "nvim";
      pager = "delta";
    };
    init.defaultBranch = "master";
    merge = {
      conflictStyle = "diff3";
      tool = "vim_mergetool";
    };
    mergetool."vim_mergetool" = {
      cmd = "nvim -f -c \"MergetoolStart\" \"$MERGED\" \"$BASE\" \"$LOCAL\" \"$REMOTE\"";
      prompt = false;
    };
    pull.rebase = false;
    push.autoSetupRemote = true;
    url = {
      "https://github.com/".insteadOf = "gh:";
      "ssh://git@github.com".pushInsteadOf = "gh:";
      "https://gitlab.com/".insteadOf = "gl:";
      "ssh://git@gitlab.com".pushInsteadOf = "gl:";
    };
    # https://news.ycombinator.com/item?id=31009675 Unsafe on share drives
    safe.directory = "*";
  };

  rg = "${pkgs.ripgrep}/bin/rg";
in {
  programs.jujutsu = {
    enable = true;
  };
  programs.jjui.enable = true;
}
