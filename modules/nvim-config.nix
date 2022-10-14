{ pkgs, ... }:

let
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
}
