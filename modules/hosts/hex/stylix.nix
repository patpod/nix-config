{ self, inputs, ... }:
{
  flake.nixosModules.stylix = {
    imports = [
      inputs.stylix.nixosModules.stylix
      self.commonModules.gruvbox
    ];

    stylix.enable = true;
  };
}
