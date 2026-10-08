{
  self,
  inputs,
  lib,
  ...
}:
{
  # `flake.darwinModules` is not a standard flake-parts output. Declaring it
  # explicitly narrows its type to plain `attrs`, which stops the module
  # system from performing a deep type-check pass over the merged submodule
  # tree. Without this, evaluating `darwinConfigurations` reaches through
  # `home-manager.extraSpecialArgs.inputs.flake-parts.inputs.nixpkgs-lib` and
  # fails, because `nixpkgs-lib` is a stripped subset that lacks
  # `maintainers/maintainer-list.nix`.
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "A merged set of darwin modules";
  };

  config.flake.darwinConfigurations."LHQGQ5M2XX" = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs self; };

    modules = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
      self.darwinModules.mac-app-util
      self.darwinModules.homebrew
      self.darwinModules.config
      self.darwinModules.sysPackages
      self.darwinModules.home-manager
      self.darwinModules.patrick-be
      self.darwinModules.netscope
      self.darwinModules.localsend
      self.darwinModules.stylix
      self.darwinModules.desktop-utils
      {
        features.darwin.netscope.enable = true;
        features.darwin.localsend.enable = true;
        features.darwin.desktop-utils.enable = true;

        features.darwin.homebrew = {
          enable = true;
          user = "patrick.podbregar";
          taps = {
            "docker/tap" = inputs.docker-tap;
            "nickustinov/tap" = inputs.nickustinov-tap;
            "pulumi/tap" = inputs.pulumi-tap;
          };
          brews = [
            "azure-cli"
            "kubetail"
            "opencode"
            "pulumi/tap/pulumi"
            "libpq"
          ];
          casks = [
            "connectmenow"
            "cryptomator"
            "docker-desktop"
            "gpg-suite"
            "kde-connect"
            "macfuse"
            "nextcloud"
            "onedrive"
            "proton-mail"
            "veracrypt"
            "vivaldi"
            "nickustinov/tap/itsypad"
          ];
        };
      }
    ];
  };
}
