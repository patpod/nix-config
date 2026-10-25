{ inputs, ... }:
{
  flake.homeModules.herdr =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
