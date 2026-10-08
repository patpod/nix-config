{ ... }:
{
  flake.homeModules.node-dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.node-dev;
    in
    {
      options.features.home.node-dev = {
        enable = lib.mkEnableOption "Node, Javascript and Typescript dev tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          pnpm
          vtsls
          nodejs
          typescript
          eslint
          prettier
        ];
      };
    };
}
