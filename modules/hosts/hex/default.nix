{ self, inputs, ... }:
{
  flake.nixosConfigurations.hex = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      self.nixosModules.hexConfiguration
      self.nixosModules.patrick
      self.nixosModules.bluetooth
    ];
  };
}
