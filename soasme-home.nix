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

  home.file.".profile".text = ''
export PATH="$HOME/.nix-profile/bin:$PATH"
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
}
