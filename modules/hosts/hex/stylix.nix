{ self, inputs, ... }:
{
  flake.nixosModules.stylix =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
        self.commonModules.gruvbox
      ];

      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = true;

        # These targets emit deprecation/unsupported warnings with the current inputs.
        targets = {
          qt.enable = false;
        };

        cursor = {
          package = pkgs.capitaine-cursors-themed;
          name = "Capitaine Cursors (Gruvbox)";
          size = 24;
        };
      };
    };
}
