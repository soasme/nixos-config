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
  ];

  home.file.".profile".text = ''
export PATH="$HOME/.nix-profile/bin:$PATH"
  '';

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
