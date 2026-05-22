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
        ];

        extraConfig = ''
          # General settings
          set-option -g status-position top
          set -g status-justify left

          # Allow passthrough of escape sequences (needed for the display images)
          set -gq allow-passthrough on
          set -g visual-activity off

          # Keep the current path when creating a new pane or window
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"

          # -----------------------------------------------------------------------------
          # Status Left: OS Logo + Session + Prefix + Window List
          # -----------------------------------------------------------------------------
          set -g status-left-length 100

          # CRITICAL: Remove the default space injected between windows
          set -g window-status-separator ""

          # The final arrow dynamically checks if Window 1 is active (#{==:#{active_window_index},1}). 
          # If YES -> background becomes colour2 (Green) to blend seamlessly into the active window.
          # If NO  -> background becomes default (Black/Transparent) to blend into inactive windows.
          set -g status-left "#[bg=colour4,fg=colour0,bold]#{?client_prefix,#[bg=colour1],}   #S #[fg=colour4,nobold]#{?client_prefix,#[fg=colour1],}#{?#{==:#{active_window_index},1},#[bg=colour2],#[bg=default]}"

          # -----------------------------------------------------------------------------
          # Window Status: Seamless Powerline transitions
          # -----------------------------------------------------------------------------
          # Inactive window format: Clean text on default background
          set -g window-status-format "#[fg=colour7,bg=default] #I  #W "

          # Active window format
          # If this is Window 1, skip the leading arrow (since status-left already drew it perfectly).
          # Otherwise, draw a default-to-green arrow to transition from the previous inactive window.
          set -g window-status-current-format "#{?#{==:#{window_index},1},,#[fg=default,bg=colour2]}#[fg=colour0,bg=colour2,bold] #I  #W #[fg=colour2,bg=default,nobold,nounderscore,noitalics]"

          # -----------------------------------------------------------------------------
          # Status Right: Clock + Gitmux + CPU/RAM
          # -----------------------------------------------------------------------------
          set -g status-right-length 150

          # Section 1: Clock (Yellow background)
          # Section 2: Gitmux (Magenta background, executing the binary directly from the Nix store)
          # Section 3: CPU & RAM (Cyan background, using the tmux-cpu plugin variables)
          set -g status-right "#[fg=colour3,bg=default]#[bg=colour3,fg=colour0,bold]  %H:%M:%S #[fg=colour5,bg=colour3]#[bg=colour5,fg=colour0] #(${lib.getExe pkgs.gitmux} -cfg ${config.xdg.configHome}/gitmux/gitmux.conf \"#{pane_current_path}\")#[fg=colour6,bg=colour5]#[bg=colour6,fg=colour0]  #{cpu_percentage}  #{cpu_temp}  #{ram_percentage} "

          # -----------------------------------------------------------------------------
          # Plugin Initialization (Must be at the very bottom!)
          # -----------------------------------------------------------------------------
          # We manually run the plugin script here so it can successfully parse the 
          # status-right string we just defined above.
          run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
        '';
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
