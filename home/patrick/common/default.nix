{ config, pkgs, ... }:

{
  imports = [
    ../../common/core
    ./shell
  ];

  home = {
    username = "patrick";
    homeDirectory = "/home/patrick";

    stateVersion = "25.11";
  };
}
