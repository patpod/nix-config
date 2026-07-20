# This modules holds generic devtools and utilities which are usually installed
# on all my devlopment machines.
{ self, inputs, ... }:
{
  flake.homeModules.devtools =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.devtools;
    in
    {
      options.features.home.devtools = {
        enable = lib.mkEnableOption "Generic dev tools and utilities";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          # Taskfile.dev automation
          go-task
          # TOML toolkit
          taplo
        ];
      };
    };
}
