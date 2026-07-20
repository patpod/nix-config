{ config, lib, ... }: {

  flake.darwinModules.homebrew =
    { config, pkgs, ... }:
    let
      cfg = config.features.darwin.homebrew;
    in
    {
      options.features.darwin.homebrew = {
        enable = lib.mkEnableOption "managed Homebrew for macOS";

        casks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of proprietary GUI apps to install via Homebrew Casks.";
          example = [
            "vivaldi"
            "raycast"
          ];
        };

        brews = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of CLI tools to install via Homebrew formulas (prefer nixpkgs when possible).";
        };
      };

      config = lib.mkIf cfg.enable {
        nix-homebrew = {
          enable = true;

          enableRosetta = true;

          user = "patrick.podbregar";
          autoMigrate = true;
        };

        homebrew = {
          enable = true;
          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
          };

          casks = cfg.casks;
          brews = cfg.brews;
        };

      };
    };
}
