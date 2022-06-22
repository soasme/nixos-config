{ pkgs, ... }:

{
  home.username = "soasme";
  home.homeDirectory = "/home/soasme";

  home.stateVersion = "22.05";

  home.shellAliases = {
    g = "git";
  };

  home.packages = [
    pkgs.fd
    pkgs.direnv
    pkgs.autojump
    pkgs.wget
    pkgs.python3
  ];

  home.file.".bash_profile".text = ''
exec zsh
'';
  home.file.".profile".text = ''
export PATH="$HOME/.nix-profile/bin:$PATH"
exec zsh
  '';

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      startup = [
        { command = "xrandr --output Virtual-1 --mode 1920x1080 &"; always = true; }
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
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "random";
      plugins = [
        "git"
        "vi-mode"
        "direnv"
        "autojump"
        "docker"
        "kubectl"
      ];
    };
  };

  programs.neovim = let
    # This specifies the source for building nvim-lualine plugin.
    nvim-lualine = pkgs.vimUtils.buildVimPlugin {
      name = "nvim-lualine";
      buildPhase = ":";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-lualine";
        repo = "lualine.nvim";
        rev = "3362b28f917acc37538b1047f187ff1b5645ecdd";
        url =
          "https://github.com/nvim-lualine/lualine.nvim/archive/3362b28f917acc37538b1047f187ff1b5645ecdd.tar.gz";
        sha256 = "0pfkh7zhnwhbfdcild5vayymw4vqzcfb31nq1y33pk1zlvpwxksv";
      };
    };
    nvim-tokyonight = pkgs.vimUtils.buildVimPlugin {
      name = "nvim-tokyonight.nvim";
      buildPhase = ":";
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "tokyonight.nvim";
        rev = "8223c970677e4d88c9b6b6d81bda23daf11062bb";
        url =
          "https://github.com/folke/tokyonight.nvim/archive/8223c970677e4d88c9b6b6d81bda23daf11062bb.tar.gz";
        sha256 = "1rzg0h0ab3jsfrimdawh8vlxa6y3j3rmk57zyapnmzpzllcswj0i";
      };
    };
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
      vimPlugins.nvim-treesitter
      vimPlugins.suda-vim
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

      nvim-lualine
      nvim-tokyonight
    ];
    extraConfig = ''
      lua <<EOF
      ${nvim-tokyonight-config}

      ${nvim-lualine-config}

      ${nvim-treesitter-config}
      EOF
    '';
  };


}
