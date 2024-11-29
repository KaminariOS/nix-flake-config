{
  pkgs,
  full,
  lib,
  ...
}: let
  # preferPath = command: default:
  #   pkgs.writeShellScript "${command}-wrapper" ''
  #     if command -v ${command}; then
  #         exec ${command} "$@"
  #     else
  #         exec ${default} "$@"
  #     fi
  #   '';
  entryBetween = before: after: data: {inherit data before after;};
  inherit (lib) optionals;
in {
  programs.neovim-flake = {
    enable = true;
    settings = let
      isMaximal = full;
    in {
      vim = {
        viAlias = false;
        vimAlias = false;
        preventJunkFiles = true;
        lineNumberMode = "number";
        useSystemClipboard = true;
        searchCase = "smart";
        configRC.custom = let vimrc = builtins.readFile ./init.vim; in entryBetween ["basic"] [] vimrc;
        startPlugins = with pkgs.vimPlugins; (optionals isMaximal [
            vim-nix
            # a universal set of defaults that (hopefully) everyone can agree on.
            vim-sensible
            # Automate infrastructure on any cloud
            # vim-tmux-navigator
            vim-twig
            vim-vue
            vimtex
          ]
          ++ [
            multiple-cursors
            # cs"'
            lsp-colors-nvim
            lsp_extensions-nvim

            # vim-airline
            vim-cpp-enhanced-highlight
            vim-fish
            # :G git command
            vim-fugitive
            #vim-hcl
            vim-localvimrc

            # https://github.com/nanotee/zoxide.vim
            zoxide-vim

            #Debugging

            promise-async

            # https://github.com/kevinhwang91/nvim-ufo
            nvim-ufo
            # fold-preview-nvim
          ]);
        debugMode = {
          enable = false;
          level = 20;
          logFile = "/tmp/nvim.log";
        };
      };

      vim.lsp = {
        formatOnSave = !true;
        lspkind.enable = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      vim.debugger = {
        nvim-dap = {
          enable = isMaximal;
          ui.enable = isMaximal;
        };
      };

      vim.languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        enableDAP = isMaximal;

        nix.enable = true;
        html.enable = isMaximal;
        clang = {
          enable = isMaximal;
          cHeader = true;
          # lsp.server = "clangd";
        };
        sql.enable = false;
        rust = {
          enable = true;
          crates.enable = true;
        };
        tex.enable = isMaximal;
        ts.enable = isMaximal;
        go.enable = isMaximal;
        zig.enable = false;
        python.enable = isMaximal;
        dart.enable = false;
        elixir.enable = false;
        markdown = {
          enable = true;
          glow.enable = true;
        };
        yaml.enable = isMaximal;
        cmake.enable = true;
        json.enable = true;
        vim.enable = isMaximal;
        toml.enable = true;
        java.enable = isMaximal;
        bash.enable = true;
        terraform.enable = isMaximal;
        vue.enable = isMaximal;
        # svelte.enable = true;
      };

      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        scrollBar.enable = true;
        smoothScroll.enable = true;
        cellularAutomaton.enable = true;
        fidget-nvim.enable = !true;
        highlight-undo = {
          enable = true;
        };
        indentBlankline = {
          enable = true;
          fillChar = null;
          eolChar = null;
          scope.enabled = true;
        };
        cursorline = {
          enable = true;
          lineTimeout = 0;
        };
      };

      vim.statusline = {
        lualine = {
          enable = true;
          # theme = "catppuccin";
        };
      };

      vim.theme = {
        enable = true;
        name = "nightfox";
        style = "auto";
        transparent = true;
      };
      vim = {
        autopairs.enable = true;
        autosaving.enable = true;
        telescope.enable = true;
        spellChecking = {
          enable = true;
          # Ensure that the :DirtytalkUpdate command is executed after install and update
          enableProgrammingWordList = isMaximal;
        };
      };
      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };

      vim.filetree = {
        nvimTree = {
          enable = true;
          renderer = {
            rootFolderLabel = true;
          };
          view = {
            width = 25;
          };
          actions = {
            openFile = {
              quitOnOpen = true;
            };
          };
          # openTreeOnNewTab = false;
          openOnSetup = false;
          diagnostics = {
            enable = true;
            showOnDirs = true;
          };
          git = {
            enable = true;
          };
          updateFocusedFile = {
            enable = true;
            updateRoot = false;
            ignoreList = [];
          };
          modified = {
            enable = true;
          };
          renderer = {
            highlightGit = true;
            highlightModified = "all";
            highlightOpenedFiles = "all";
            icons = {
              gitPlacement = "after";
              modifiedPlacement = "before";
              show = {
                git = true;
                modified = true;
              };
            };
          };
        };
      };

      vim.tabline = {
        nvimBufferline.enable = true;
      };

      vim.treesitter = {
        enable = true;
        autotagHtml = true;
        context.enable = true;
        fold = true;
        # fold = true;
      };

      vim.binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      vim.git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions = false; # throws an annoying debug message
      };

      vim.minimap = {
        minimap-vim.enable = true;
        codewindow.enable = true; # lighter, faster, and uses lua for configuration
      };

      vim.dashboard = {
        dashboard-nvim.enable = true;
        alpha.enable = true;
      };

      vim.notify = {
        nvim-notify = {
          enable = true;
        };
      };

      vim.projects = {
        project-nvim.enable = true;
      };

      vim.utility = {
        ccc.enable = true;
        icon-picker.enable = true;
        diffview-nvim.enable = true;
        surround = {
          enable = true;
        };
        motion = {
          hop.enable = true;
          leap.enable = true;
        };
      };

      vim.notes = {
        obsidian.enable = false; # FIXME neovim fails to build if obsidian is enabled
        orgmode.enable = false;
        mind-nvim.enable = true;
        todo-comments.enable = true;
      };

      vim.terminal = {
        toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };

      vim.ui = {
        noice.enable = true;
        smartcolumn.enable = !true;
        # Whether to enable vim-illuminate: automatically highlight other uses of the word under the cursor.
        illuminate.enable = true;
      };

      vim.assistant = {
        copilot.enable = false;
        #tabnine.enable = false; # FIXME: this is not working because the plugin depends on an internal script to be ran by the package manager
      };

      vim.session = {
        nvim-session-manager = {
          enable = true;
          autoloadMode = "Disabled";
        };
        neoconf = {
          enable = true;
        };
      };

      vim.gestures = {
        gesture-nvim.enable = false;
      };

      vim.comments = {
        comment-nvim.enable = true;
      };

      vim.presence = {
        presence-nvim = {
          enable = true;
          auto_update = true;
          image_text = "The Superior Text Editor";
          client_id = "793271441293967371";
          main_image = "neovim";
          rich_presence = {
            editing_text = "Editing %s";
          };
        };
      };
    };
  };

  xdg.configFile."nvim/config.lua".source = pkgs.substituteAll {
    src = ./init.lua;
    #   pyrightLangserver = preferPath "pyright-langserver" "${pkgs.pyright}/bin/pyright-langserver";
    #   rustAnalyzer = preferPath "rust-analyzer" "${pkgs.rust-analyzer}/bin/rust-analyzer";
  };
  xdg.configFile."nvim/init.vim".source = ./init.vim;
}
