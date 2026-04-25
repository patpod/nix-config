{ self, inputs, ... }:
{

  flake.homeModules.tmux =
    { pkgs, config, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "screen-256color";
        mouse = true;
        keyMode = "vi";
        prefix = "C-b";
        baseIndex = 1;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
        ];

        extraConfig = ''
          # General settings
          set-option -g status-position top

          # Allow passthrough of escape sequences (needed for the display images)
          set -gq allow-passthrough on
          set -g visual-activity off

          # Keep the current path when creating a new pane or window
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"

          # Status Bar Layout
          # set -g status-interval 5
          # set -g status-left-length 100
          # set -g status-right-length 100
          # set -g status-left '#{E:@catppuccin_status_session}'
          # set -gF status-right '#{@catppuccin_status_directory}'
          # set -agF status-right '#{@catppuccin_status_gitmux}'
          # set -agF status-right '#{E:@catppuccin_status_date_time}'
        '';
      };

    };
}
