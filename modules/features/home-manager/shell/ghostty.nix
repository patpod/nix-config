{ self, inputs, ... }:
{
  flake.homeModules.ghostty =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.ghostty = {
        enable = true;
        package = inputs.ghostty.packages.${pkgs.system}.default;
      };
    };
}
