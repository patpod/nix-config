{ self, inputs, ... }:
{
  flake.homeModules.azure-dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.azure-dev;
    in
    {
      options.features.home.azure-dev = {
        enable = lib.mkEnableOption "Azure devlopment tooling";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          azure-cli
        ];
      };
    };
}
