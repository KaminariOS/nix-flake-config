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
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    delta = {
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
    aliases = {
      amend = "commit --amend -m";
      fixup = "!f(){ git reset --soft HEAD~\${1} && git commit --amend -C HEAD; };f";
      loc = "!f(){ git ls-files | ${rg} \"\\.\${1}\" | xargs wc -l; };f"; # lines of code
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      pso = "push origin";
      plo = "pull origin";
      pop = "reset --soft HEAD^1";
      url = "remote set-url origin";
      rs = "restore";
      ch = "checkout";
    };
    extraConfig = gitConfig;
    ignores = [
      "*.bloop"
      "*.bsp"
      "*.metals"
      ".idea/*"
      "*.metals.sbt"
      "*metals.sbt"
      "*.direnv"
      #"*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
      "*hie.yaml" # ghcide files
      "*.mill-version" # used by metals
      "*.jvmopts" # should be local to every project
    ];
    signing = {
      key = "0x5710C5966568BAC5";
    };
    userEmail = "chankocyo@gmail.com";
    userName = config.home.username;
  };

  home.packages = with pkgs; [git-crypt git-annex];
}
