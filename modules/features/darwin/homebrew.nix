{ config, lib, ... }: {

  flake.darwinModules.homebrew = { config, ... }:
  let
    cfg = config.features.darwin.homebrew;
  in 
  {
    options.features.darwin.homebrew = {
      enable = lib.mkEnableOption "managed Homebrew for macOS";

      casks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of proprietary GUI apps to install via Homebrew Casks.";
        example = [ "vivaldi" "raycast" ];
      };
      
      brews = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of CLI tools to install via Homebrew formulas (prefer nixpkgs when possible).";
      };

      masApps = lib.mkOption {
        type = lib.types.attrsOf lib.types.ints.positive;
        default = { };
        description = "Mac App Store apps to install. Dictionary mapping app name to its Apple ID.";
        example = { "Bitwarden" = 1352778147; };
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
        masApps = cfg.masApps;
      };
    };
  };
}
