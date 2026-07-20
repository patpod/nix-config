# The list of systems this flake supports.
#
# Follows the `nix-systems` convention (see https://github.com/nix-systems/nix-systems):
# a plain list of system strings that transitive `nix-systems`-style inputs
# can `follow` to restrict which platforms they enumerate.
#
# Wired into `flake.nix` as the `systems` input (flake = false), and used to
# override e.g. `hunk.inputs.bun2nix.inputs.systems.follows = "systems"` so
# bun2nix does not force evaluation of `nixpkgs.legacyPackages.x86_64-darwin`,
# which is unsupported on nixpkgs 26.11+.
[
  "aarch64-darwin"
  "x86_64-linux"
]
