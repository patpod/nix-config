_: {
  flake.nixosModules.printing =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.nixos.printing;
    in
    {
      options.features.nixos.printing = {
        enable = lib.mkEnableOption "Enable printing";
      };

      config = lib.mkIf cfg.enable {
        # Enable CUPS to print documents.
        services.printing = {
          enable = true;
          drivers = [
            pkgs.epson-escpr
          ];
        };
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
    };
}
