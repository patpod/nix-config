_: {
  flake.darwinModules.desktop-utils =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.darwin.desktop-utils;
    in
    {
      options.features.darwin.desktop-utils = {
        enable = lib.mkEnableOption "MacOS Desktop utilities that should be available on all my Macs";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [
          pkgs.shottr
        ];
      };
    };
}
