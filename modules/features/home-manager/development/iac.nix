{ self, inputs, ... }:
{
  flake.homeModules.iac =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.iac;
    in
    {
      options.features.home.iac = {
        enable = lib.mkEnableOption "Infrastructure-as-Code tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          pulumi
          pulumiPackages.pulumi-nodejs
          pulumiPackages.pulumi-python
        ];
      };
    };
}
