{ self, inputs, ... }:
{
  flake.nixosConfigurations.hex = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      self.nixosModules.hexConfiguration
      self.nixosModules.patrick
      self.nixosModules.bluetooth
      self.nixosModules.sops
      self.nixosModules.tailscale
      self.nixosModules.desktop
      self.nixosModules.hexFingerprintReader
      {
        # The host specific secrets file
        sops.defaultSopsFile = ./secrets.yaml;
      }
    ];

  };
}
