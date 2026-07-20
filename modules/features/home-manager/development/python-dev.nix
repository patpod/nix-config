{ self, inputs, ... }:
{
  flake.homeModules.python-dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.python-dev;
    in
    {
      options.features.home.python-dev = {
        enable = lib.mkEnableOption "Python development tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          ruff
          pyright
          uv
        ];
      };
    };
}
