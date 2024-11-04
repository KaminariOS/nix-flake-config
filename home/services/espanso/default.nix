{
  config,
  pkgs,
  ...
}: {
  services = {
    #cross platform text expander in Rust.
    espanso = {
      # enable = true;
      package = pkgs.espanso-wayland;
      matches = {
        base = {
          matches = [
            {
              #     # Simple text replacement
              trigger = ":espanso";
              replace = "Hi there!";
            }
            {
              # For ChatGPT
              trigger = ":ag";
              replace = "Analyze the grammar in English";
            }

            {
              # For ChatGPT
              trigger = ":is";
              replace = "How to say the following in Spanish: ";
            }

            {
              trigger = ":now";
              replace = "It's {{currentdate}} {{currenttime}}";
            }
            {
              trigger = ":hello";
              replace = "line1\nline2";
            }
            {
              regex = ":hi(?P<person>.*)\\.";
              replace = "Hi {{person}}!";
            }
          ];
        };
        global_vars = {
          global_vars = [
            {
              name = "currentdate";
              type = "date";
              params = {format = "%d/%m/%Y";};
            }
            {
              name = "currenttime";
              type = "date";
              params = {format = "%R";};
            }
          ];
        };
      };
    };
  };
}
