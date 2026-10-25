{ self, ... }:
{
  flake.homeModules.nixos-common = {

    imports = [
      self.homeModules.features
    ];

    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
