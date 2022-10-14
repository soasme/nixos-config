{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.home-manager.url = github:nix-community/home-manager;
  inputs.nixos-hardware.url = github:NixOS/nixos-hardware;
  inputs.neovim-config.url = "path:./modules/neovim";

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.devbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
    nixosConfigurations.pibox = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules = [ ./configurations/pibox.nix ];
    };
  };
}
