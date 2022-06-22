{ pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "22.05";

  home.packages = [
    pkgs.wget
  ];

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
