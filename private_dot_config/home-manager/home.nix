{ pkgs, lib, config, ... }:
let
  unstable = import <nixos-unstable> {}; #a nix-channel called nixos-unstable has to exist
  # Minimal laTex configuration for emacs inheriting from schemes
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
  # Custom OpenUSD package while oficial is included
  #openusd = with import <nixpkgs> {};
  #   (python3Packages.callPackage /home/diego/dev/OpenUSD/openusd.nix {
  #     alembic = pkgs.alembic;
  #   });
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "diego";
  home.homeDirectory = "/home/diego";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  #Overlay in order to get some packages from unstable
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  nixpkgs.overlays = [
    (final: previous: {
      distrobox = unstable.distrobox;
      #blender = (unstable.blender.override { cudaSupport = true; });
      blender = unstable.blender;
      hledger = unstable.hledger;
      hledger-ui = unstable.hledger-ui;
      hledger-web = unstable.hledger-web;
      hledger-iadd = unstable.hledger-iadd;
      leftwm = unstable.leftwm;
      picom-next = unstable.picom-next;
      #qtile = unstable.qtile;
      hyprland = unstable.hyprland;
      #openusd = unstable.openusd;
    })
  ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    #cli-programs
    gotop
    ncdu
    duf
    ranger
    just
    #podman
    #distrobox

    # cli productivity
    taskwarrior3
    vit
    #hledger
    #hledger-web
    #hledger-ui
    #hledger-iadd

    # ffmpeg_6-full
    mpv
    djv
    #blender
    cmus

    # for Emacs
    tree-sitter
    graphviz
    tex
    aspell
    aspellDicts.en
    aspellDicts.en-science
    aspellDicts.en-computers
    aspellDicts.es
    hunspell
    wordnet

    # Testing tiling WMs
    #qtile
    rofi
    nitrogen
    dunst

    #openusd
    #chromium
    xfce.thunar
    xfce.thunar-volman
    xfce.catfish

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
    # # fonts?

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (writeShellScriptBin "alacritty_gl" ''
	WINIT_X11_SCALE_FACTOR=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia nixGL alacritty
    '')

    (writeShellScriptBin "alacritty_gl_tmux" ''
	WINIT_X11_SCALE_FACTOR=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia nixGL alacritty -e tmux
    '')

    (writeShellScriptBin "nixgl_update" ''
        nix-channel --update && nix-env -iA nixgl.auto.nixGLDefault
    '')

    (writeShellScriptBin "blender_gl" ''
        nixGL blender "$@"
    '')

    (writeShellScriptBin "org-capture-fix" ''
   emacsclient --eval "(progn (load-theme 'doom-one t) (+org-capture/open-frame \"$1\" \"$2\"))"
    '')

    (writeShellScriptBin "set-monitor-alienware" ''
      xrandr --output HDMI-0 --off --output DP-0 --mode 3440x1440 --rate 174.96
    '')

    (writeShellScriptBin "set-monitor-secondary" ''
      xrandr --output DP-0 --off --output HDMI-0 --mode 1920x1080 --rate 59.94
    '')

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/diego/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.desktopEntries = {
    #blender = {
    #  name = "Blender";
    #  genericName = "3D modeler";
    #  comment = "(nixGL) 3D modeling, animation, rendering and post-production";
    #  exec = "nixGL blender %f";
    #  icon = "blender";
    #  terminal = false;
    #  type = "Application";
    #  categories = ["Graphics"];
    #  mimeType = ["application/x-blender"];
    #};
  };

  programs.fish = {
    enable = true;
    shellInit = "
      starship init fish | source
      zoxide init fish | source
    ";
    plugins = [ 
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
    shellAliases = {
      sudo = "sudo --preserve-env=PATH env";
      em = "emacsclient -c -a ''";
      emt = "emacsclient -nw";
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      directory = {
        truncation_length = 4;
        truncation_symbol = "…/";
      };
      directory.substitutions = {
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        "Videos" = " ";
        "/mnt/auto/buho/remote/proyectos" = "🏗️ 🦉";
        "/mnt/auto/buho/remote" = "🦉";
        "/mnt/auto/nuc/remote" = "👾";
      };
      custom.home = {
        when = ''
               test "{$HOME}" = "{$PWD}"
             '';
        style = "bold cyan";
        #symbol = ' ';
        symbol = "🏠 ";
        format = "[$symbol]($style)";
      };
      nodejs = { detect_extensions = []; };
      java = { disabled = true; };
      lua = { disabled = true; };
      perl = { detect_extensions = ["pl" "pm"]; };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.fd = {
    enable = true;
    hidden = true; #Add -H flag by deffault
  };

  programs.fzf = {
    enable = true;
    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.eza = {
    enable = true;
    icons = true;
    extraOptions = [];
  };

  programs.bat = {
    enable = true;
    config = { };
  };

  programs.ripgrep = {
    enable = true;
    arguments = [ ];
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  programs.htop = {
    enable = true;
    settings = { };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    shell = "/home/diego/.nix-profile/bin/fish";
    prefix = "C-a";
    mouse = true;
    extraConfig = "
      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '\"'
      unbind %

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # don't rename windows automatically
      set-option -g allow-rename off

      bind-key Bspace run-shell -b 'ranger'
    ";
    plugins = with pkgs; [
    	tmuxPlugins.sensible 
      tmuxPlugins.nord
      tmuxPlugins.prefix-highlight
      tmuxPlugins.tmux-fzf
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 5;
        y = 5;
      };
      window.opacity = 0.94;
      font.normal = {
        family = "FiraCode Nerd Font";
	style = "Regular";
      };
      font.bold = {
        family = "FiraCode Nerd Font";
	style = "Bold";
      };
      font.size = 12.0;
      shell.program = "/home/diego/.nix-profile/bin/fish";
      #shell.args = ["-c tmux"];
      # Nord theme
      colors = {
        primary.background = "0x2E3440";
        primary.foreground = "0xD8DEE9";
        normal.black = "0x3B4252";
        normal.red = "0xBF616A";
        normal.green = "0xA3BE8C";
        normal.yellow = "0xEBCB8B";
        normal.blue = "0x81A1C1";
        normal.magenta = "0xB48EAD";
        normal.cyan = "0x88C0D0";
        normal.white = "0xE5E9F0";
        bright.black = "0x4C566A";
        bright.red = "0xBF616A";
        bright.green = "0xA3BE8C";
        bright.yellow = "0xEBCB8B";
        bright.blue = "0x81A1C1";
        bright.magenta = "0xB48EAD";
        bright.cyan = "0x8FBCBB";
        bright.white = "0xECEFF4";
      };
      # For importing other themes:
      #import = [ "{path-to-theme}.yml" ];
    };
  };

  programs.rbw = {
    enable = true;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "ayu_mirage";
      editor = {
        line-number = "absolute";
        mouse = true;
      };
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm epkgs.nerd-icons epkgs.emojify ];
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };

  systemd.user.services = {
    tmux-daemon = {
      Unit = {
        Description= "Start tmux in detached session";
      };
      Service = {
        Type = "forking";
        ExecStart = "/home/diego/.nix-profile/bin/tmux new-session -s %u -d";
        ExecStop = "/home/diego/.nix-profile/bin/tmux kill-session -t %u";
      };
    };
  };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    bookmarks = {
      d = "~/Documents";
      D = "~/Downloads";
      p = "~/Pictures";
      v = "~/Videos";
    };
    extraPackages = with pkgs; [ ffmpegthumbnailer mediainfo sxiv ];
    plugins = {
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.0";
        sha256 = "sha256-Hpc8YaJeAzJoEi7aJ6DntH2VLkoR6ToP6tPYn3llR7k=";
      }) + "/plugins";
      mappings = {
        c = "fzcd";
        f = "finder";
        v = "imgview";
      };
    };
  };

  services.syncthing = {
    enable = true;
    tray = {
      enable = false;
    };
  };

}
