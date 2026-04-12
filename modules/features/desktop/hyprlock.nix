{ inputs, ... }:
{
  flake.homeModules.hyprlock = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };

        auth = {
          "fingerprint:enabled" = true;
        };

        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        # The password entry circle
        input-field = [
          {
            monitor = "";
            size = "250, 50";
            position = "0, -80";
            halign = "center";
            valign = "center";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 24, 37)";
            outline_thickness = 5;
            placeholder_text = "<i>Password...</i>";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
