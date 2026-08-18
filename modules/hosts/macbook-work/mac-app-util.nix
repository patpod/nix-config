{ inputs, ... }:
{
  flake.darwinModules.mac-app-util = {
    imports = [
      inputs.mac-app-util.darwinModules.default
    ];
  };
}
