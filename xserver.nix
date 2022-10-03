{ pkgs }:

{
  enable = true;
  layout = "us";
  dpi = 192;

  xkbOptions = "ctrl:swapcaps";

  desktopManager = {
    xterm.enable = false;
    wallpaper.mode = "fill";
  };

  displayManager = {
    defaultSession = "none+i3";
    lightdm.enable = true;
  };

  windowManager = {
    i3.enable = true;
    i3.extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock
    ];
  };

  libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
}
