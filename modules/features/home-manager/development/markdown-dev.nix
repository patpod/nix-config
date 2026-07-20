{ self, inputs, ... }:
{
  flake.homeModules.markdown-dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.markdown-dev;
    in
    {
      options.features.home.markdown-dev = {
        enable = lib.mkEnableOption "Markdown development and preview tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          markdownlint-cli2
          marksman
        ];
      };
    };
}
