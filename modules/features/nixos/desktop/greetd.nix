{
  flake.nixosModules.greetd = {
    programs.regreet = {
      enable = true;
    };

    services.greetd = {
      enable = true;
    };

    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
