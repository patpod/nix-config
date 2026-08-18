{ inputs, ... }:
{
  flake.homeModules.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;

        package =
          if pkgs.stdenv.hostPlatform.isDarwin then
            pkgs.ghostty-bin
          else
            inputs.ghostty.packages.${pkgs.system}.default;
      };
    };
}
