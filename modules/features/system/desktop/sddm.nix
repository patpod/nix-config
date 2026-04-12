{ self, inputs, ... }:
{

  flake.nixosModules.sddm =
    { pkgs, ... }:
    {
      services.displayManager.sddm.enable = true;

      security = {
        pam = {
          services = {
            sddm = {
              # Disable fingerprint authentication in sddm to avoid the
              # race condition the leads to a long delay after entering
              # the password because sddm waits until the fprint auth
              # times out.
              fprintAuth = false;
              # Tell SDDM to automatically unlock the keyring on login
              enableGnomeKeyring = true;
              enableKwallet = true;
            };
            login = {
              # Also disable fprintAuth on the login service to make sure
              # it does not override the sddm setting.
              fprintAuth = false;
            };
          };
        };
      };
    };
}
