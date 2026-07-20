{ self, inputs, ... }:
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
          # typescript-go ships both `tsc` and `tsgo`; its `tsc` conflicts with
          # the classic `typescript` package's `tsc` in buildEnv. Lower its
          # priority so classic `tsc`/`tsserver` win (versions match), while
          # `tsgo` remains available for explicit invocation.
          (lib.lowPrio typescript-go)
        ];
      };
    };
}
