{
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
}
