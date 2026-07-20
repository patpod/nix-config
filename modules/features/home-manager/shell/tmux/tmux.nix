{ self, inputs, ... }:
{

  flake.homeModules.tmux =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {

      home.packages =
        with pkgs;
        [
          bc
        ]
        ++ lib.optionals stdenv.isLinux [
          sysstat
          lm_sensors # Required to read the Ryzen CPU temperatures
        ];

      programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "screen-256color";
        mouse = true;
        keyMode = "vi";
        prefix = "C-b";
        baseIndex = 1;
        clock24 = true;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          tmux-powerline
        ];

        extraConfig = ''
          # General settings
          set-option -g status-position top
          set -g status-justify left

          # Enable True Color (24-bit) specifially for Ghostty
          set-option -sa terminal-overrides ",xterm-ghostty*:Tc"

          # Allow passthrough of escape sequences (needed for the display images)
          set -gq allow-passthrough on
          set -g visual-activity off

          # Keep the current path when creating a new pane or window
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"

          # 

          # -----------------------------------------------------------------------------
          # Plugin Initialization (Must be at the very bottom!)
          # -----------------------------------------------------------------------------
          # We manually run the plugin script here so it can successfully parse the 
          # status-right string we just defined above.
          # run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
        '';
      };

      # -----------------------------------------------------------------------------
      # tmux-powerline Configuration
      # -----------------------------------------------------------------------------
      xdg.configFile."tmux-powerline/config.sh".source = ./powerline-config.sh;
      xdg.configFile."tmux-powerline/themes/powerline-stylix-theme.sh".source =
        pkgs.replaceVars ./powerline-stylix-theme.sh
          {
            # Base surfaces
            default_bg = config.lib.stylix.colors.withHashtag.base00;
            selection_bg = config.lib.stylix.colors.withHashtag.base02;
            default_fg = config.lib.stylix.colors.withHashtag.base05;
            # Additional slots for gruvbox-mapped segments (following
            # PetrusZ/tmux-powerline-gruvbox-colorscheme's group -> segment mapping)
            status_bg = config.lib.stylix.colors.withHashtag.base01;
            subtle_fg = config.lib.stylix.colors.withHashtag.base04;
            bright_bg = config.lib.stylix.colors.withHashtag.base07;
            accent_green = config.lib.stylix.colors.withHashtag.base0B;
            accent_yellow = config.lib.stylix.colors.withHashtag.base0A;
          };

      # -----------------------------------------------------------------------------
      # Gitmux Configuration
      # -----------------------------------------------------------------------------
      # We also define the gitmux configuration natively in Home Manager so it matches
      # the exact styling requirements you asked for.
      xdg.configFile."gitmux/gitmux.conf".text = ''
        tmux:
          symbols:
            branch: ' '
            hashprefix: ':'
            track: ' '
            staged: '+ '
            conflict: 'X '
            modified: '* '     # Inconspicuous symbol
            untracked: '? '
            stashed: '⚑ '
            clean: ' '
            insertions: 'Σ '
            deletions: 'Δ '
          styles:
            # We explicitly set bg=colour5 across the board here. 
            # This prevents gitmux from ever accidentally injecting a default/black background reset.
            clear: '#[fg=colour0,bg=colour5,nobold]'
            state: '#[fg=colour0,bold,bg=colour5]'
            branch: '#[fg=colour0,bold,bg=colour5]'
            remote: '#[fg=colour0,bg=colour5]'
            staged: '#[fg=colour0,bg=colour5]'
            conflict: '#[fg=colour0,bg=colour5]'
            modified: '#[fg=colour0,bg=colour5]'
            untracked: '#[fg=colour0,bg=colour5]'
            stashed: '#[fg=colour0,bg=colour5]'
            clean: '#[fg=colour0,bg=colour5]'
          layout: [branch, " - ", flags]
          options:
            branch_max_len: 0
            branch_trim: right
      '';
    };
}
