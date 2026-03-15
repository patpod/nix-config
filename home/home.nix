{ config, pkgs, ... }:

{
  imports = [
    ./programs
    ./shell
  ];

  home = {
    username = "patrick";
    homeDirectory = "/home/patrick";

    stateVersion = "25.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
