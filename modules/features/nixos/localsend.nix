_: {
  flake.nixosModules.localsend =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.nixos.localsend;
    in
    {
      options.features.nixos.localsend = {
        enable = lib.mkEnableOption "LocalSend peer-to-peer sharing application";
      };

      config = lib.mkIf cfg.enable {
        programs.localsend = {
          enable = true;
          openFirewall = true;
        };
      };
    };
}
