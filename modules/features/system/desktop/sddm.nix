{ self, inputs, ... }:
{

  flake.nixosModules.sddm =
    { pkgs, ... }:
    {
      services.displayManager.sddm.enable = true;
    };
}
