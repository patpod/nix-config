{ inputs, ... }:
{
  flake.homeModules.niri =
    { pkgs, ... }:
    {

      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.niri = {
        settings = {
          prefer-no-csd = true;

          spawn-at-startup = [
            # TODO: Clarify if this is really needed.
            # Inject ALL environment variables (including PAM keyring tokens) into systemd and D-Bus
            {
              command = [
                "systemctl"
                "--user"
                "import-environment"
              ];
            }
            {
              command = [
                "dbus-update-activation-environment"
                "--systemd"
                "--all"
              ];
            }
            # Enable Noctalia Shell
            { command = [ "noctalia-shell" ]; }
            # Launch polkit authentication agent
            { command = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; }
          ];

          input = {
            keyboard.xkb = {
              layout = "eu";
            };

            touchpad = {
              natural-scroll = true;
              tap = true;
            };

            mouse = {
              natural-scroll = true;
            };
          };

          outputs = {
            "eDP-1" = {
              scale = 2;

              position = {
                x = 5120;
                y = 0;
              };

              mode = {
                width = 2880;
                height = 1920;
                refresh = 120.0;
              };
              variable-refresh-rate = true;
            };

            "Samsung Electric Company C49RG9x H1AK500000" = {
              scale = 1.0;
              position = {
                x = 0;
                y = 0;
              };
              mode = {
                width = 5120;
                height = 1440;
                refresh = 119.970;
              };
              variable-refresh-rate = false;
            };
          };

          layout = {
            always-center-single-column = true;
            center-focused-column = "on-overflow";
          };

          binds = {
            "Mod+Shift+Slash".action.show-hotkey-overlay = { };

            "Mod+T".action.spawn = "ghostty";
            "Mod+B".action.spawn = "vivaldi";

            "Mod+O".action.toggle-overview = { };
            "Mod+Q".action.close-window = { };
            "Mod+F".action.maximize-column = { };
            "Mod+C".action.center-column = { };

            "Mod+H".action.focus-column-left = { };
            "Mod+L".action.focus-column-right = { };
            "Mod+K".action.focus-window-up = { };
            "Mod+J".action.focus-window-down = { };

            "Mod+Shift+H".action.move-column-left = { };
            "Mod+Shift+L".action.move-column-right = { };
            "Mod+Shift+K".action.move-window-up = { };
            "Mod+Shift+J".action.move-window-down = { };

            "Mod+Ctrl+H".action.set-column-width = "-5%";
            "Mod+Ctrl+L".action.set-column-width = "+5%";
            "Mod+Ctrl+J".action.set-window-height = "-5%";
            "Mod+Ctrl+K".action.set-window-height = "+5%";

            "Mod+U".action.focus-workspace-up = { };
            "Mod+D".action.focus-workspace-down = { };
            "Mod+Shift+U".action.move-column-to-workspace-up = { };
            "Mod+Shift+D".action.move-column-to-workspace-down = { };

            # Focus between monitors
            "Mod+Alt+H".action.focus-monitor-left = { };
            "Mod+Alt+L".action.focus-monitor-right = { };

            # Move the active column to the other monitor
            "Mod+Shift+Alt+H".action.move-column-to-monitor-left = { };
            "Mod+Shift+Alt+L".action.move-column-to-monitor-right = { };

            # Toggle floating state for the focused window
            "Mod+Shift+F".action.toggle-window-floating = { };

            # If you have a floating window, bring it to the front
            "Mod+Shift+C".action.switch-focus-between-floating-and-tiling = { };

            # Lock screen
            "Mod+Ctrl+Q".action.spawn = [ "hyprlock" ];

            # Jump directly to workspaces
            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;

            # Throw the current window to a specific workspace
            "Mod+Shift+1".action.move-column-to-workspace = 1;
            "Mod+Shift+2".action.move-column-to-workspace = 2;
            "Mod+Shift+3".action.move-column-to-workspace = 3;
            "Mod+Shift+4".action.move-column-to-workspace = 4;
            "Mod+Shift+5".action.move-column-to-workspace = 5;

            "Mod+Space".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "launcher"
              "toggle"
            ];

            # Audio controls
            "XF86AudioRaiseVolume".action.spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.1+"
            ];
            "XF86AudioLowerVolume".action.spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.1-"
            ];
            "XF86AudioMute".action.spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ];

            # Brightness controls
            "XF86MonBrightnessUp".action.spawn = [
              "brightnessctl"
              "set"
              "10%+"
            ];
            "XF86MonBrightnessDown".action.spawn = [
              "brightnessctl"
              "set"
              "10%-"
            ];
          };
        };
      };

      programs.noctalia-shell = {
        enable = true;
      };
    };
}
