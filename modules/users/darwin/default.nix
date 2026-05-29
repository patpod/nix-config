{ self, inputs, ... }:
{

  flake.darwinModules.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
