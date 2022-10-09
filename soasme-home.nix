{ pkgs, ... }:

{
  home.username = "soasme";
  home.homeDirectory = "/home/soasme";

  home.stateVersion = "22.05";

  home.shellAliases = {
    g = "git";
    lock = "i3lock & sleep 3 && xset dpms force off";
  };

  home.packages = [
    pkgs.gnumake
    pkgs.fd
    pkgs.ripgrep
    pkgs.direnv
    pkgs.autojump
    pkgs.jq
    pkgs.rsync
    pkgs.xclip
    pkgs.hub
    pkgs.obs-studio
  ];

  home.file.".profile".text = ''
export PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      startup = [
        # adjust resolution.
        # { command = "xrandr --output Virtual-1 --mode 1920x1200 &"; always = true; }
        # enable copy-paste sharing with host.
        # { command = "spice-vdagent &"; always = true; }
      ];
      terminal = "alacritty"; 
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "zsh";
        args = ["--login"];
      };
    };
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "soasme";
    userEmail = "soasme@gmail.com";
    aliases = {
      s = "status";
      sc = "status --cached";
      cp = "cherry-pick";
      co = "commit";
      ch = "checkout";
    };
    extraConfig = {
      safe.directory = ["/etc/nixos"];
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.rofi = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    sessionVariables = {
      EDITOR = "vi";
    };
    oh-my-zsh = {
      enable = true;
      theme = "random";
      plugins = [
        "git"
        "fzf"
        "vi-mode"
        "direnv"
        "autojump"
        "docker"
        "kubectl"
      ];
    };
  };

  programs.neovim = let
    nvim-lualine-config = ''
      require'lualine'.setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '>', right = '<'},
          section_separators = { left = '|>', right = '<|'},
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {
            "location",
            {
              "diagnostics",
              sources = { "nvim_diagnostic" }
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      }
    '';
    nvim-treesitter-config = ''
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {"lua", "rust", "python", "javascript", "hcl", "vim"},
        sync_install = false,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    '';
    nvim-tokyonight-config = ''
      vim.g.tokyonight_style = "storm"
      vim.g.tokyonight_italic_functions = true
      vim.cmd[[colorscheme tokyonight]]
    '';
    coc-config = ''
      let g:coc_global_extensions = ['coc-tabnine']
      inoremap <silent><expr> <c-space> coc#refresh()
      inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    '';
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    extraPackages = [
      pkgs.gcc
      # This is essential for enabling neoformat formating nix files.
      pkgs.nixfmt
      pkgs.black
      pkgs.nodejs
      pkgs.nodePackages.prettier
      pkgs.terraform
      pkgs.terraform-ls
    ];
    plugins = with pkgs; [
      # Good support for nix files.
      vimPlugins.vim-nix

      # :Git :Gsplit, :Gedit, etc.
      vimPlugins.vim-fugitive

      # `gcc`, `gc<motion>`: quick commenting.
      vimPlugins.vim-commentary

      # :Files, :Buffers, :Commits, etc.
      vimPlugins.fzf-vim

      # syntax highlight 
      vimPlugins.nvim-treesitter

      # :SudaWrite, :SudaRead
      vimPlugins.suda-vim

      # Hmm, I'm just a code reviewer, not a programmer now.
      vimPlugins.copilot-vim

      # This enpowers autoformat for certain programming languages.
      {
        plugin = vimPlugins.neoformat;
        config = ''
          let g:neoformat_enabled_nix = ["nixfmt"]
          let g:neoformat_enabled_python = ["black"]
	  let g:neoformat_enabled_terraform = ["terraform"]
        '';
      }

      # This beautifies the startup scene for vim.
      {
        plugin = vimPlugins.vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }

      # Put useful information at the bottom.
      vimPlugins.lualine-nvim

      # theme.
      vimPlugins.tokyonight-nvim
    ];
    extraConfig = ''
      lua <<EOF
      ${nvim-tokyonight-config}

      ${nvim-lualine-config}

      ${nvim-treesitter-config}

      vim.api.nvim_set_option("clipboard","unnamed")
      EOF
    '';
    coc.enable = true;
    coc.pluginConfig = ''
      ${coc-config}
    '';
  };


}
