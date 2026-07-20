{
  description = "Patrick's System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Systems this configuration supports. Kept as a local flake so we can
    # constrain transitive `nix-systems`-style inputs (e.g. bun2nix via hunk)
    # to only the platforms we actually build for. This avoids evaluating
    # `nixpkgs.legacyPackages.x86_64-darwin`, which throws on nixpkgs 26.11+.
    systems = {
      url = "path:./systems.nix";
      flake = false;
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-wrapper-modules
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Ghostty official flake
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri Wayland window manager
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell for Wayland
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My neovim Configuration
    nvim-config = {
      url = "github:patpod/nvim-config";
      flake = false;
    };

    # Homebrew Support
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # mac-app-util to make applications available via spotlight
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };

    # Docker Homebrew Tap (used for instaling sbx)
    docker-tap = {
      url = "github:docker/homebrew-tap";
      flake = false;
    };

    # Nickustinov Homebrew Tap (used for installing itsypad)
    nickustinov-tap = {
      url = "github:nickustinov/homebrew-tap";
      flake = false;
    };

    # Pulumi Homebrew Tap
    pulumi-tap = {
      url = "github:pulumi/homebrew-tap";
      flake = false;
    };

    # Hunk Diff Tool
    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
      # bun2nix (transitive) enumerates all 4 systems by default, which forces
      # eval of `nixpkgs.legacyPackages.x86_64-darwin` — unsupported on 26.11.
      # Restrict it to the systems we actually target.
      inputs.bun2nix.inputs.systems.follows = "systems";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree ./modules)
      ];

      systems = inputs.nixpkgs.lib.mkForce [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    };
}
