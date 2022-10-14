{
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
  extraConfig = { safe.directory = [ "/etc/nixos" ]; };
}
