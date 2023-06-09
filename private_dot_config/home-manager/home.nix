{ config, pkgs, ... }:

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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
   
    pkgs.starship
    pkgs.htop
    pkgs.gotop
    pkgs.ncdu
    pkgs.duf
    pkgs.zoxide
    pkgs.fzf
    pkgs.fd
    pkgs.exa
    pkgs.bat
    pkgs.ripgrep
    pkgs.graphviz
    pkgs.ffmpeg_6-full
    pkgs.mpv
    pkgs.tealdeer
    pkgs.djv
    pkgs.ranger
    pkgs.taskwarrior
    pkgs.vit
    pkgs.cmus
    pkgs.tree-sitter

    pkgs.qtile
    pkgs.picom
    pkgs.rofi
    pkgs.nitrogen
    pkgs.dunst

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.writeShellScriptBin "alacritty_gl" ''
	WINIT_X11_SCALE_FACTOR=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia nixGL alacritty
    '')

    (pkgs.writeShellScriptBin "alacritty_gl_tmux" ''
	WINIT_X11_SCALE_FACTOR=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia nixGL alacritty -e tmux
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
    };

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
      window.opacity = 0.95;
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = "
      set number
    ";
    extraLuaConfig = "
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true
      vim.cmd[[colorscheme nord]]
      local function my_on_attach(bufnr)
        local api = require 'nvim-tree.api'
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
        vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
      end
      require('nvim-tree').setup{
        on_attach = my_on_attach,
      }
      require('lualine').setup {
        options = {
          theme = 'nord'
        }
      }
      require('telescope').setup()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      require('telescope').load_extension('zoxide')
    ";
    plugins = with pkgs.vimPlugins; [
      vim-nix
      yankring
      nvim-lspconfig
      nvim-treesitter
      nvim-tree-lua
      nvim-cmp
      ale
      nord-nvim
      nerdcommenter
      indent-blankline-nvim
      nvim-web-devicons
      gitsigns-nvim
      barbar-nvim
      telescope-nvim
      telescope-zoxide
      lualine-nvim
    ];
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
  };

  services.emacs = {
    enable = true;
    #client.arguments = [ "-c" "-a \"emacs\"" ];
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

}
