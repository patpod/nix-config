{ self, inputs, ... }:
{
  flake.nixosConfigurations.hex = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hexConfiguration ];
  };
}
