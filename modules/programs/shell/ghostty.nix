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

      package = inputs.ghostty.packages.${pkgs.system}.default;

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

}
