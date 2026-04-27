{ self, inputs, ... }:
{
  flake.homeModules.noctalia =
    { lib, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      stylix.targets.noctalia-shell.enable = true;

      programs.noctalia-shell = {
        enable = true;
        settings = {
          bar = {
            showCapsule = false;
            outerCorners = false;
            backgroundOpacity = lib.mkForce 0.5;
            useSeparateOpacity = true;
          };
        };
      };
    };
}
