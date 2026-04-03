{
  inputs,
  ...
}:
{
  imports = [
    inputs.wrappers.flakeModules.wrappers
  ];

  flake.wrappers.ghostty =
    {
      pkgs,
      config,
      wlib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;

      constructFiles."ghostty-config" = {
        content = ''
          font-family = "FiraCode Nerd Font"
        '';

        relPath = "etc/ghostty/config";
      };

      flags = {
        "--config-file" = {
          sep = "=";
          data = config.constructFiles."ghostty-config".path;
        };
      };
    };

  flake.homeModules.ghostty =
    { config, lib, ... }:
    {
      imports = [
        (inputs.wrappers.lib.mkInstallModule {
          name = "ghostty";
          value = inputs.self.wrapperModules.ghostty;
          loc = [
            "home"
            "packages"
          ];
        })
      ];

      options.my.programs.ghostty.enable = lib.mkEnableOption "Wrapped Ghostty Terminal";

      config = lib.mkIf config.my.programs.ghostty.enable {
        wrappers.ghostty.enable = true;
      };
    };
}
