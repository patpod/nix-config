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

        package = if pkgs.stdenv.isDarwin then
          pkgs.ghostty-bin
        else
          inputs.ghostty.packages.${pkgs.system}.default;
      };
    };
}
