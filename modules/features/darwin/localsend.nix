_: {
  flake.darwinModules.localsend =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.darwin.localsend;
    in
    {
      options.features.darwin.localsend = {
        enable = lib.mkEnableOption "LocalSend peer-to-peer sharing application";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.localsend ];
      };
    };
}
