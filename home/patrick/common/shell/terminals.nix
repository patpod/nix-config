{ pkgs, inputs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;

    settings = {
      "background-opacity" = 0.9;
    };
  };
}
