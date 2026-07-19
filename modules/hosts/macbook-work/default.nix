{
  self,
  inputs,
  lib,
  ...
}:
{

  options.flake.darwinModules = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "A merged set of darwin modules";
  };

  config = {
    flake.darwinConfigurations."LHQGQ5M2XX" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };

      modules = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        self.darwinModules.homebrew
        self.darwinModules.config
        self.darwinModules.sysPackages
        self.darwinModules.home-manager
        self.darwinModules.patrick-be
        {
          features.darwin.homebrew = {
            enable = true;
            brews = [
              "kubetail"
              "opencode"
              "podman"
            ];
            casks = [
              "connectmenow"
              "cryptomator"
              "google-chrome"
              "gpg-suite"
              "macfuse"
              "nextcloud"
              "onedrive"
              "podman-desktop"
              "proton-mail"
              "setapp"
              "signal"
              "veracrypt"
              "vivaldi"
            ];
          };
        }
      ];
    };
  };
}
