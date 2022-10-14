# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, home-manager, nixos-hardware, neovim-config, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../hardwares/pibox.nix
    nixos-hardware.nixosModules.raspberry-pi-4
    home-manager.nixosModule
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.hostName = "pibox"; # Define your hostname.

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Pacific/Auckland";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];
  environment.systemPackages = with pkgs; [
    vim # why nano?
    wget # why curl?
    fd # why find?
    git # for downloading repos.
    python3 # for basic automation.
    imagemagick # for displaying images.
    chromium # for web browsing.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    3000 # for regular node app
    8000 # for regular web app
    8080 # for regular web app
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  ## Extra customizations

  ## Enable docker.
  virtualisation.docker.enable = true;

  ## Setup window environment.
  services.xserver = import ../xserver.nix { inherit pkgs; };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  home-manager.users.root = import ../root-home.nix;

  security.sudo.wheelNeedsPassword = false;

  users.users.soasme = {
    isNormalUser = true;
    description = "soasme@gmail.com";
    home = "/home/soasme";
    extraGroups = [ "wheel" ];
  };

  home-manager.users.soasme = let
    nvim-config = import ../modules/nvim-config.nix { inherit pkgs; };
    zsh-config = import ../modules/zsh-config.nix;
    git-config = import ../modules/git-config.nix;
  in import ../soasme-home.nix {
    inherit pkgs nvim-config zsh-config git-config;
  };

  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  hardware.opengl.enable = true;

  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  boot.loader.raspberryPi.firmwareConfig = ''
    dtparam=audio=on
  '';

  # enabling bluetooth support
  # <https://nixos.wiki/wiki/Bluetooth>
  hardware.bluetooth.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/123725
  hardware.enableRedistributableFirmware = true;

  # pairing bluetooth devices.
  services.blueman.enable = true;

  # https://nix-community.github.io/home-manager/index.html#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
  programs.dconf.enable = true;
}
