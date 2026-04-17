{ self, inputs, ... }:
{
  flake.nixosModules.smbShares =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [ pkgs.cifs-utils ];

      sops.secrets."truenas-credentials" = {
        sopsFile = ./secrets.yaml;
      };

      fileSystems."/home/patrick/tmp" = {
        device = "//truenas.bouncyhaus.com/tmp";
        fsType = "cifs";
        options = [
          # Standard systemd automount options for laptops
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"

          # Make sure you can read/write to it as your normal user
          "uid=1000"
          "gid=100"

          # This is the magic line!
          # It dynamically injects the path to the decrypted secret.
          "credentials=${config.sops.secrets."truenas-credentials".path}"
        ];
      };
    };
}
