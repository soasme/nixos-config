{ pkgs, zsh-config, nvim-config, git-config, ... }:

let
  username = "soasme";
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "22.05";

  home.shellAliases = {
    g = "git";
    screensaver = "xset dpms force off";
    lock = "i3lock & sleep 3 && screensaver";
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
        args = [ "--login" ];
      };
    };
  };

  programs.home-manager.enable = true;

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

  programs.rofi = { enable = true; };

  programs.git = git-config;
  programs.zsh = zsh-config;
  programs.neovim = nvim-config;

}
