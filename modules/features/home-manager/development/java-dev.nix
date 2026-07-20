{ self, inputs, ... }:
{
  flake.homeModules.java-dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.java-dev;
    in
    {
      options.features.home.java-dev = {
        enable = lib.mkEnableOption "Java Development Tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          jdk25
          maven
        ];
      };
    };
}
