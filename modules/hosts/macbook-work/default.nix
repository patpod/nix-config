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
      specialArgs = { inherit inputs self; };

      modules = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        self.darwinModules.homebrew
        self.darwinModules.config
        self.darwinModules.sysPackages
        self.darwinModules.home-manager
        self.darwinModules.patrick-be
        self.darwinModules.netscope
        self.darwinModules.stylix
        {
          # TODO Move this into the homebrew darwin module
          nix-homebrew = {
            enable = true;
            user = "patrick.podbregar";
            mutableTaps = true;

            taps = {
              "docker/tap" = inputs.docker-tap;
              "nickustinov/tap" = inputs.nickustinov-tap;
              "pulumi/tap" = inputs.pulumi-tap;
            };

            trust = {
              taps = [
                "docker/tap"
                "nickustinov/tap"
                "pulumi/tap"
              ];
            };
          };

          features.darwin.netscope.enable = true;

          features.darwin.homebrew = {
            enable = true;
            brews = [
              "azure-cli"
              "kubetail"
              "opencode"
              "podman"
              "pulumi/tap/pulumi"
              "libpq"
            ];
            casks = [
              "connectmenow"
              "cryptomator"
              "docker-desktop"
              "google-chrome"
              "gpg-suite"
              "macfuse"
              "nextcloud"
              "onedrive"
              "podman-desktop"
              "proton-mail"
              "setapp"
              "docker/tap/sbx"
              "signal"
              "veracrypt"
              "vivaldi"
              "nickustinov/tap/itsypad"
            ];
          };
        }
      ];
    };
  };
}
