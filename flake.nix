{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      felipe-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./laptop ];
      };
    };
  };
}
