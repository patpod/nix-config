{
  description = "Patrick's System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Ghostty official flake
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {

      nixosConfigurations.hex = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/hex/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users.patrick = import ./home/home.nix;
            };
          }
        ];
      };
    };
}
