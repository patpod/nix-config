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
          # Github CoPilot CLI
          github-copilot-cli
          # Open Code Claude authentication helper
          opencode-claude-auth
          # Claude Code coding agent
          claude-code
        ];

        programs.opencode = {
          enable = true;
          settings = {
            plugins = [ "opencode-claude-auth" ];
          };
        };
      };
    };
}
