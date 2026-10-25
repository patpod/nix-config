{ inputs, self, ... }:
{
  flake.homeModules.darwin-common = {
    imports = [
      inputs.mac-app-util.homeManagerModules.default
      self.homeModules.features
    ];

    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
