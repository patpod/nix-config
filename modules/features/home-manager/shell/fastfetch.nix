{ self, inputs, ... }:
{
  flake.homeModules.fastfetch = {

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          padding = {
            right = 1;
          };
        };
        display = {
          size = {
            binaryPrefix = "iec";
          };
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "terminal"
          "cpu"
          "gpu"
          "memory"
          "break"
          "colors"
        ];
      };
    };
  };
}
