{
  pkgs,
  full,
  lib,
  ...
}: let
  inherit (lib) optionals;
  rustcli = with pkgs; (optionals full [
      # Put a rainbow in everything you `cat` to the console. Like lolcat
      dotacat

      aichat
      argc
      jq
      # xsv
      # A fast duplicate file finder
      # ddh

      tealdeer
      grex # A command-line tool for generating regular expressions from user-provided test cases

      # pastel is a command-line tool to generate, analyze, convert and manipulate colors. It supports many different color formats and color spaces like RGB (sRGB), HSL, CIELAB, CIELCh as well as ANSI 8-bit and 24-bit representations.
      pastel

      # Rust REPL
      evcxr

      wthrr # Weather companion for the terminal

      hyperfine # command-line benchmarking tool

      htmlq
      jless
      jql
      # file server
      miniserve

      # CLI tool for saving web pages as a single HTML file
      monolith

      xcp # xcp is a (partial) clone of the Unix cp command. It is not intended as a full replacement, but as a companion utility with some more user-friendly feedback and some optimisations that make sense under certain tasks (see below).

      kalker # https://github.com/PaddiM8/kalker

      # fend is an arbitrary-precision unit-aware calculator.
      # > 5'10" to cm
      # 177.8 cm
      fend

      # Pipr is a commandline pipe-building tool, written in Rust!
      pipr

      # stock price
      tickrs

      # This is choose, a human-friendly and fast alternative to cut and (sometimes) awk
      choose

      # Analyzer of executables using a terminal user interface
      binsider

      # Background rust code checker
      bacon

      # Executes commands in response to file modifications
      watchexec

      # ouch stands for Obvious Unified Compression Helper.
      ouch
    ]
    ++ [
      # atac
      # # Better cd
      # zoxide
      # tokei # Count your code, quickly.
      # ps
      procs

      gitui
      sd # is an intuitive find & replace CLI.
      bandwhich
      hexyl
      # Shell history
      atuin

      # A new way to see and navigate directory trees (get an overview of a directory, even a big one; find a directory then cd to it; never lose track of file hierarchy while you search; manipulate your files, ...)
      # broot

      delta # Better diff

      ripgrep # fast grep
      ripgrep-all

      # navi # cheatsheet
      # skim # Half of our life is spent on navigation: files, lines, commands… You need skim! It is a general fuzzy finder that saves you time.

      bottom # alternative to htop & ytop
      du-dust # disk usage/free utility
      # eza # a better `ls`
      fd # "find" for files

      # dog is a command-line DNS client.
      # dog

      # dua (-> Disk Usage Analyzer) is a tool to conveniently learn about the usage of disk space of a given directory. It's parallel by default and will max out your SSD, providing relevant information as fast as possible. Optionally delete superfluous data, and do so more quickly than rm.
      dua

      # Efficient duplicate file finder and remover
      fclones

      # rargs # Rargs is kind of xargs + awk with pattern-matching support. https://github.com/lotabout/rargs
      # systeroid — A more powerful alternative to sysctl(8).
      # systeroid
      # Like df
      duf
      # lfs

      # Command-line Git information tool
      onefetch
      # Fast, minimal and customizable system information frontend.
      macchina

      # File manager
      # yazi

      # Replacement for rm with focus on safety, ergonomics and performance
      rm-improved

      viu # A command-line application to view images from the terminal written in Rust
    ]);

  security = with pkgs; [
    rustcat # Port listener and reverse shell
    rustscan # Port scanner
    feroxbuster # Fast, simple, recursive content discovery tool

    ropgadget # Tool to search for gadgets in binaries to facilitate ROP exploitation
    pwndbg # Exploit Development and Reverse Engineering with GDB Made Easy

    metasploit # pentesting

    hashcat # Fast password cracker
    hashcat-utils # Small utilities that are useful in advanced password cracking

    aircrack-ng
    kismet # Wireless network sniffer
    burpsuite # An integrated platform for performing security testing of web applications
  ];

  cargoAddons = with pkgs; [
    cargo-audit
    cargo-feature
    cargo-readme
    cargo-geiger
    cargo-msrv
    cargo-expand
    cargo-bloat
    cargo-flamegraph
    cargo-license
    cargo-supply-chain
    cargo-hack
    cargo-deny
    cargo-llvm-lines
    cargo-outdated
    cargo-udeps
  ];

  nixAddons = with pkgs; (optionals full [
      cachix # nix caching
      nix-du

      nix-diff
      nix-tree
      nix-prefetch-git
      # Run unpatched binaries on Nix/NixOS easily.
      manix
      statix
      # Comma runs software without installing it.
      comma
    ]
    ++ [
      any-nix-shell
    ]);

  lsps = with pkgs; (optionals full [
    # rnix-lsp # nix lsp server
    # rust-analyzer
    # gopls
    # haskell-language-server
    # java-language-server
    # texlab
    # taplo-lsp # A TOML toolkit written in Rust
    # sumneko-lua-language-server
    # nodePackages.vim-language-server
    # nodePackages.yaml-language-server
    # nodePackages.vscode-json-languageserver
    # nodePackages.bash-language-server
    # nodePackages.svelte-language-server
    # jdt-language-server
    # marksman
    #   wgsl_analyzer
    #python-lsp-server
    # cmake-language-server
    # ccls

    # ruff # An extremely fast Python linter and code formatter, written in Rust.
    code-minimap
  ]);

  defaultShell = with pkgs; (optionals full [
      distrobox
      ddgr
      xclip
      clang-tools
      rr
      taskwarrior3
      taskwarrior-tui
      dmidecode
      gptfdisk

      iw # iw is a new nl80211 based CLI configuration utility for wireless devices. The old tool iwconfig, which uses Wireless Extensions interface, is deprecated and it's strongly recommended to switch to iw and nl80211.

      pandoc
      # texlive.combined.scheme-small
      tectonic

      sysvtools

      gcalcli
      # gtasks
      # gkeep
      nyancat # the famous rainbow cat!

      picocom

      usbutils
      pciutils

      prettyping # a nicer ping

      fortune
      poppler_utils # pdftotext
      lldb
      google-cloud-sdk

      xpra

      screen

      glow

      awscli2
      gemini-cli

      minikube
      kubernetes
      terraform
    ]
    ++ [
      # killall # kill processes by name
      # ranger # terminal file explorer
      direnv

      # gnumake
      # cmake
      # gcc
      # gdb

      #An implementation of the Debug Adapter Protocol for Python
      # python310Packages.debugpy

      # xsel # clipboard support (also for neovim)

      zip
      unzip

      #rust-gdb

      # python3
      python3.pkgs.dbus-python
      # iftop

      file

      gh
      sshfs

      gemini-cli
      # Postgres cli
      # pgcli
    ]);
in
  defaultShell
  ++ rustcli
  # ++ cargoAddons
  ++ nixAddons
  ++ lsps
