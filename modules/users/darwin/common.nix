{ self, inputs, ... }:
{
  flake.homeModules.darwin = {
    imports = [
      inputs.mac-app-util.homeManagerModules.default
    ];

    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
