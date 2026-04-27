{ self, inputs, ... }:
{
  flake.commonModules.gruvbox =
    { config, pkgs, ... }:
    {
      stylix.image = ../../../assets/wallpapers/gruvbox-astronaut-2880x1920.png;

      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

      stylix.fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sizes = {
          terminal = 12;
          applications = 11;
        };
      };

      stylix.cursor = {
        package = pkgs.capitaine-cursors-themed;
        name = "Capitaine Cursors (Gruvbox)";
        size = 24;
      };
    };
}
