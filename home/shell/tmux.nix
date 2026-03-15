{ pkgs, ... }:
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
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'slanted'
          set -g @catppuccin_window_number_position 'right'
          set -g @catppuccin_window_status 'no'
          set -g @catppuccin_window_default_text '#W'
          set -g @catppuccin_window_current_fill 'number'
          set -g @catppuccin_window_current_text '#W'
          set -g @catppuccin_window_current_color '#{E:@thm_surface_2}'
          set -g @catppuccin_date_time_text ' %d.%m. %H:%M'
          set -g @catppuccin_status_module_text_bg '#{E:@thm_mantle}'
        '';
      }
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
      set -g status-interval 5
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left '#{E:@catppuccin_status_session}'
      set -gF status-right '#{@catppuccin_status_directory}'
      set -agF status-right '#{@catppuccin_status_gitmux}'
      set -agF status-right '#{E:@catppuccin_status_date_time}'
    '';
  };

}
