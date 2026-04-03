{ self, inputs, ... }:
{

  flake.nixosModules.sops =
    { pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
        age
      ];

      sops = {
        defaultSopsFormat = "yaml";

        # This file has to be available before the config
        # is used
        age.keyFile = "/var/lib/sops/key.text";
      };
    };
}
