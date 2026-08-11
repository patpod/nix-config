{ self, inputs, ... }:
{
  flake.nixosModules.kde =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.nixos.kde;
    in
    {
      options.features.nixos.kde = {
        enable = lib.mkEnableOption "KDE Plasma desktop environment";
      };

      config = lib.mkIf cfg.enable {
        services = {
          desktopManager.plasma6.enable = true;
          # Default display manager for Plasma
          displayManager.plasma-login-manager.enable = true;
        };

        environment = {
          systemPackages = with pkgs; [
            kdePackages.kdeconnect-kde
          ];
        };

      };
    };
}
