{ pkgs, ghostty, ... }:
{
  programs.ghostty = {
    enable = true;
    package = ghostty.packages.${pkgs.system}.default;

    settings = {
      "background-opacity" = 0.9;
    };
  };
}
