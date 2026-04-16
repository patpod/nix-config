{ self, inputs, ... }:
{

  flake.nixosModules.desktop =
    { pkgs, lib, ... }:
    {

      imports = [
        self.nixosModules.greetd
        self.nixosModules.niri
      ];

      # Enbale gnome-keyring because niri does not come
      # with a scret service out of th box
      services.gnome.gnome-keyring.enable = true;

      security = {
        pam = {
          # Enbale hyprlock lock screen but disable the fingerprint reader
          # pam authentication. We will use hyprlocks native functionality
          # on home-manager level
          services.hyprlock.fprintAuth = lib.mkForce false;
        };
        # Enable polkit agent to display password prompts
        polkit.enable = true;
      };

      environment.systemPackages = with pkgs; [
        # A graphical UI to manage the GNOME Keyring
        seahorse
      ];
    };
}
