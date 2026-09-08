_: {
  flake.homeModules.fastfetch = {

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          # source omitted so fastfetch auto-detects the OS logo
          # (NixOS logo on NixOS, Apple logo on macOS).
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
