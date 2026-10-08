{ self, inputs, ... }:
{
  flake.nixosConfigurations.hex = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      self.nixosModules.hexConfiguration
      self.nixosModules.home-manager
      self.nixosModules.patrick
      self.nixosModules.bluetooth
      self.nixosModules.sops
      self.nixosModules.tailscale
      self.nixosModules.kde
      self.nixosModules.localsend
      self.nixosModules.hexFingerprintReader
      self.nixosModules.smbShares
      self.nixosModules.stylix
      self.nixosModules.video-editing
      self.nixosModules.printing
      {
        # The host specific secrets file
        sops.defaultSopsFile = ./secrets.yaml;

        features.nixos.kde.enable = true;
        features.nixos.localsend.enable = true;
        features.nixos.video-editing.enable = true;
        features.nixos.printing.enable = true;
      }
    ];
  };
}
