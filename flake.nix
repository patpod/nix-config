{
  description = "Patrick's System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # nix-wrapper-modules
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Ghostty official flake
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        (inputs.import-tree ./modules)
      ];

      systems = [
        "x86_64-linux"
      ];
    };
}
