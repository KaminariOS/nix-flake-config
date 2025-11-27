{
  lib,
  pkgs,
  ...
} @ args: {
  programs.k9s = {
    enable = true;
  };

  programs.k9s.skins = {
    my_nord_skin = {
      k9s = {
        body = {
          fgColor = "#D8DEE9";
          bgColor = "#2E3440";
          logoColor = "#81A1C1";
        };
        prompt = {
          fgColor = "#ECEFF4";
          bgColor = "#3B4252";
          border = "rounded";
        };
        info = {
          fgColor = "#88C0D0";
          sectionColor = "#5E81AC";
        };
        dialog = {
          fgColor = "#ECEFF4";
          bgColor = "#3B4252";
          buttonFgColor = "#ECEFF4";
          buttonBgColor = "#5E81AC";
          buttonFocusFgColor = "#2E3440";
          buttonFocusBgColor = "#88C0D0";
        };
        frame = {
          border = "rounded";
          borderFgColor = "#4C566A";
        };
        views = {
          table = {
            fgColor = "#E5E9F0";
            bgColor = "#2E3440";
            header = {
              fgColor = "#88C0D0";
              bgColor = "#3B4252";
              sorterColor = "#81A1C1";
            };
            cursorFgColor = "#2E3440";
            cursorBgColor = "#88C0D0";
            markColor = "#8FBCBB";
            evenRowBgColor = "#2E3440";
            oddRowBgColor = "#3B4252";
          };
          xray = {
            fgColor = "#ECEFF4";
            bgColor = "#2E3440";
            cursorColor = "#88C0D0";
          };
          yaml = {
            keyColor = "#81A1C1";
            colonColor = "#D8DEE9";
            valueColor = "#E5E9F0";
          };
          logs = {
            fgColor = "#ECEFF4";
            bgColor = "#2E3440";
            indicator = {
              okColor = "#8FBCBB";
              warnColor = "#EBCB8B";
              errorColor = "#BF616A";
            };
          };
        };
      };
    };
  };
}
