{ lib, ... }:
{
  flake.darwinModules.homebrew =
    { config, ... }:
    let
      cfg = config.features.darwin.homebrew;
    in
    {
      options.features.darwin.homebrew = {
        enable = lib.mkEnableOption "managed Homebrew for macOS";

        user = lib.mkOption {
          type = lib.types.str;
          description = "macOS user that owns the Homebrew installation.";
          example = "patrick.podbregar";
        };

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

        taps = lib.mkOption {
          type = lib.types.attrsOf lib.types.raw;
          default = { };
          description = ''
            Third-party Homebrew taps to register with `nix-homebrew`. Keys
            are tap names (e.g. `docker/tap`); values are the tap flake
            inputs. All listed taps are automatically trusted.
          '';
          example = lib.literalExpression ''
            {
              "docker/tap" = inputs.docker-tap;
            }
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          autoMigrate = true;
          mutableTaps = true;

          inherit (cfg) user taps;
          trust.taps = lib.attrNames cfg.taps;
        };

        homebrew = {
          enable = true;
          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            # Docker Desktop updates itself; forced cask upgrades can fail on its privileged helpers.
            upgrade = false;
          };

          taps = lib.attrNames cfg.taps;
          inherit (cfg) casks brews;
        };
      };
    };
}
