{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {

      imports = [
        inputs.niri.nixosModules.niri
      ];

      programs.niri = {
        enable = true;

        # Disable test for the package build because there is a test issue issue with my gpu.
        # This does not seem to have any impact on the actual runtime
        package =
          inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable.overrideAttrs
            (oldAttrs: {
              doCheck = false;
            });
      };

      environment = {
        systemPackages = with pkgs; [
          # Enable compatibility layer for x-server applications
          xwayland-satellite
        ];

        sessionVariables = {
          # Tell Chromium/Electron apps to use Wayland natively
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
