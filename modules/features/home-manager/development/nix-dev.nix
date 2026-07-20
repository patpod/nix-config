{ self, inputs, ... }:
{
  flake.homeModules.nix-dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.nix-dev;
    in
    {
      options.features.home.nix-dev = {
        enable = lib.mkEnableOption "Nix language development tools";

        formatter = lib.mkOption {
          type = lib.types.enum [
            "nixfmt"
            "alejandra"
            "nixpkgs-fmt"
          ];
          default = "nixfmt";
          description = ''
            Which Nix formatter to install.
            `nixfmt` is the official RFC 166 formatter (recommended).
          '';
        };

        languageServer = lib.mkOption {
          type = lib.types.enum [
            "nixd"
            "nil"
          ];
          default = "nixd";
          description = "Which Nix LSP server to install.";
        };

        enableDirenv = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable direnv with nix-direnv integration for per-project shells.";
        };

        enableNixIndex = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable nix-index for `command-not-found` style lookups.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          with pkgs;
          [
            # Linter for finding antipatterns
            statix
            # Find unused code
            deadnix
            # Modern wrapper around nix commands (rebuild, clean, search, ...)
            nh
            # Pretty, parsed build output
            nix-output-monitor
            # nil nix language server
            nil
            # Diff between two system generations
            nvd
            # Interactive nix-store dependency explorer
            nix-tree
            # Generate package definitions from URLs
            nix-init
            # Update version + hashes of existing packages
            nix-update
            # Generate fetcher calls (fetchFromGitHub, etc.)
            nurl
            # Documentation search for nixpkgs / NixOS / HM options
            manix
          ]
          ++ lib.optional (cfg.formatter == "nixfmt") nixfmt
          ++ lib.optional (cfg.formatter == "alejandra") alejandra
          ++ lib.optional (cfg.formatter == "nixpkgs-fmt") nixpkgs-fmt
          ++ lib.optional (cfg.languageServer == "nixd") nixd
          ++ lib.optional (cfg.languageServer == "nil") nil;

        programs.nix-index = lib.mkIf cfg.enableNixIndex {
          enable = true;
          enableZshIntegration = true;
        };

        programs.direnv = lib.mkIf cfg.enableDirenv {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
    };
}
