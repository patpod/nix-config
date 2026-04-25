{
  flake.nixosModules.greetd =
    { pkgs, ... }:
    {
      programs.regreet = {
        enable = true;
      };

      services.greetd = {
        enable = true;
      };

      security.pam.services.greetd.enableGnomeKeyring = true;
    };
}
