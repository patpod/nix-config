{ self, inputs, ... }:
{
  flake.homeModules.nixos-common = {

    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
