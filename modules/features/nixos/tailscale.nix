{ self, inputs, ... }:
{
  flake.nixosModules.tailscale =
    { config, ... }:
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets.tailscaleAuthKey.path;
        extraUpFlags = [
          "--accept-routes"
        ];
        openFirewall = true;
      };

      sops.secrets.tailscaleAuthKey = { };

    };
}
