_: {
  flake.homeModules.obsidian =
    { config, lib, ... }:
    let
      cfg = config.features.home.obsidian;
    in
    {
      options.features.home.obsidian = {
        enable = lib.mkEnableOption "Obsidian PKM application";
      };

      config = lib.mkIf cfg.enable {
        programs.obsidian = {
          enable = true;
        };
      };
    };

}
