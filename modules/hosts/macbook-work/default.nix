{ self, inputs, lib, ...}: {

  options.flake.darwinModules = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "A merged set of darwin modules";
  };

  config = {
    flake.darwinConfigurations."LHQGQ5M2XX" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        self.darwinModules.config
        self.darwinModules.sysPackages
        self.darwinModules.home-manager
        self.darwinModules.patrick
      ];
    };
  };
}
