# This modules holds generic devtools and utilities which are usually installed
# on all my devlopment machines.
_: {
  flake.homeModules.agentic-coding =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.agentic-coding;
    in
    {
      options.features.home.agentic-coding = {
        enable = lib.mkEnableOption "AI driven development tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          # Pi coding agent
          pi-coding-agent
          # Docker agent sandbox
          docker-sbx
          # Github CoPilot CLI
          github-copilot-cli
        ];
      };
    };
}
