{
  flake.nixosModules.greetd =
    { pkgs, ... }:
    {
      programs.regreet = {
        enable = true;

        theme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-dark-gtk;
        };

        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.gruvbox-plus-icons;
        };

        cursorTheme = {
          name = "Capitaine Cursors (Gruvbox)";
          package = pkgs.capitaine-cursors-themed;
        };
      };

      services.greetd = {
        enable = true;
      };

      security.pam.services.greetd.enableGnomeKeyring = true;
    };
}
