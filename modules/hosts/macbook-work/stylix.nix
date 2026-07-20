{ self, inputs, ... }:
{
  flake.darwinModules.stylix = {
    imports = [
      inputs.stylix.darwinModules.stylix
      self.commonModules.gruvbox
    ];

    stylix = {
      enable = true;
      homeManagerIntegration.autoImport = true;
    };
  };
}
