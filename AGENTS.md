# AGENTS.md

Guide for coding agents working in this repository.

## Repository Overview

- Type: Nix flake-based system configuration.
- Flake entrypoint: `flake.nix` (uses `flake-parts` + `vic/import-tree`).
- Module tree root: `modules/` (every `.nix` file is auto-imported).
- Configured hosts:
  - NixOS: `hex`
  - nix-darwin: `LHQGQ5M2XX`

## Architecture: Dendritic Pattern

This repo follows the dendritic pattern: `flake.nix` does not list modules
manually. Instead `inputs.import-tree ./modules` walks the entire `modules/`
tree and feeds each `.nix` file to `flake-parts` as a top-level module.

Implications every agent must understand:

- Adding a file under `modules/` is enough to register it. There is no central
  import list to update.
- Every file in `modules/` is a flake-parts module. Its top-level value must be
  a function returning an attrset, and it should write into one of:
  - `flake.nixosModules.<name>` — reusable NixOS module
  - `flake.darwinModules.<name>` — reusable nix-darwin module
  - `flake.homeModules.<name>` — reusable Home Manager module
  - `flake.nixosConfigurations.<host>` / `flake.darwinConfigurations.<host>`
    — concrete host
- Modules wire themselves together by referencing each other via `self`, e.g.
  `imports = [ self.nixosModules.<name> ];` or `self.homeModules.<name>`.
- A host is composed by listing the modules it wants (see
  `modules/hosts/hex/default.nix`, `modules/hosts/macbook-work/default.nix`).
- Features are opt-in. They expose `options.features.<scope>.<name>` and gate
  their `config` with `lib.mkIf cfg.enable` (see
  `modules/features/darwin/homebrew.nix`,
  `modules/features/home-manager/git.nix`,
  `modules/features/home-manager/development/nix-dev.nix`).

### Where Things Live

- `modules/hosts/<host>/` — host composition + host-specific NixOS/Darwin config.
  - `default.nix` builds `flake.{nixos,darwin}Configurations.<host>` by listing
    the modules to include.
  - `configuration.nix` exports the host-specific NixOS/Darwin module
    (`flake.{nixos,darwin}Modules.<hostConfig>`).
  - Additional files (e.g. `hardware.nix`, `smb-shares.nix`, `stylix.nix`)
    each export their own named module.
- `modules/features/nixos/` — reusable NixOS feature modules.
  Each file exports one `flake.nixosModules.<name>`.
- `modules/features/darwin/` — reusable nix-darwin feature modules
  (`flake.darwinModules.<name>`).
- `modules/features/home-manager/` — reusable Home Manager modules
  (`flake.homeModules.<name>`); subfolders group by domain
  (`shell/`, `desktop/`, `development/`).
- `modules/features/common/` — modules used across NixOS and Darwin.
- `modules/users/` — user identity + home-manager glue:
  - `home-manager.nix` / `darwin/default.nix` — export the home-manager wiring
    modules (`useGlobalPkgs`, `useUserPackages`, `extraSpecialArgs`).
  - `users/<user>/nixos.nix` — NixOS user module (creates the user, attaches
    home-manager imports).
  - `users/darwin/<user>/default.nix` — Darwin user module (same role).
  - `users/<user>/home.nix` — the user's Home Manager profile.

### Code Segregation Rules

- NixOS-only code goes under `modules/features/nixos/` or
  `modules/hosts/<linux-host>/`. It may reference `services.*`, `boot.*`,
  `networking.*`, `programs.<pkg>.enable` (system-level), etc.
- nix-darwin-only code goes under `modules/features/darwin/` or
  `modules/hosts/<darwin-host>/`. Touch `system.*`, `homebrew.*`,
  `nix-homebrew.*`, etc.
- Home Manager code (anything in a user's `$HOME`) goes under
  `modules/features/home-manager/`. Use `home.*`, `programs.<pkg>` (HM-level),
  `xdg.*`, `wayland.*`.
- Cross-platform Home Manager modules MUST NOT branch on `pkgs.stdenv.isDarwin`
  inside themselves. Instead, the platform-specific user file
  (`modules/users/<user>/nixos.nix` vs `modules/users/darwin/<user>/default.nix`)
  decides which home modules to import.
- A Home Manager module is never imported directly into a NixOS or Darwin
  system module. It is pulled in through
  `home-manager.users.<name>.imports = [ self.homeModules.<x> ];`.

## Build, Lint, and Test Commands

Run all commands from repo root.

### Inspect Outputs

- `nix flake show --no-write-lock-file`

### Build (Validation)

- NixOS: `nix build .#nixosConfigurations.hex.config.system.build.toplevel`
- Darwin: `nix build .#darwinConfigurations.LHQGQ5M2XX.system`

### Apply / Switch (Only When Requested)

- NixOS: `sudo nixos-rebuild switch --flake .#hex`
- Darwin: `darwin-rebuild switch --flake .#LHQGQ5M2XX`

Treat switch commands as deployment; do not run unless asked.

### Lint

- `statix check .`
- `deadnix .`
- Optional auto-fix (review diff): `statix fix .`

### Formatting

- One file: `nixfmt modules/path/to/file.nix`
- All Nix files: `nixfmt $(fd -e nix)`

### "Single Test" Equivalents

No conventional test suite exists. Use targeted eval/build:

- NixOS eval: `nix eval .#nixosConfigurations.hex.config.system.build.toplevel.drvPath --raw`
- Darwin eval: `nix eval .#darwinConfigurations.LHQGQ5M2XX.system.drvPath --raw`
- No-link build (stronger check):
  - `nix build .#nixosConfigurations.hex.config.system.build.toplevel --no-link`
  - `nix build .#darwinConfigurations.LHQGQ5M2XX.system --no-link`

## Code Style Guidelines

### File and Module Structure

- A file in `modules/` is a flake-parts module. Typical shape:

  ```nix
  { self, inputs, ... }:
  {
    flake.<scope>Modules.<name> =
      { config, lib, pkgs, ... }:
      let cfg = config.features.<scope>.<name>; in
      {
        options.features.<scope>.<name> = { ... };
        config = lib.mkIf cfg.enable { ... };
      };
  }
  ```

- Outer function: `{ self, inputs, ... }:` (flake-parts module args).
- Inner function: `{ config, lib, pkgs, ... }:` (NixOS / Darwin / HM module args).
- Order inside the inner module: `imports` → `options` → `config`.

### Imports

- Reference sibling modules via `self.<scope>Modules.<name>`, never by path.
- Reference flake inputs (e.g. `inputs.sops-nix.nixosModules.sops`) directly.
- One import per line; group by domain (system, user, feature).

### Formatting

- `nixfmt` is the canonical formatter. Two-space indent.
- Long lists: one item per line.
- Avoid dense one-line attrsets when readability suffers.

### Options and Types

- Booleans: `lib.mkEnableOption "<short description>"`.
- Configurable values: `lib.mkOption` with explicit `type`, `default`,
  `description`. Common types: `bool`, `str`, `enum [ ... ]`,
  `listOf str`.
- Place every feature's options under `features.<scope>.<name>`.

### Naming Conventions

- Module export name matches the concept, not the file path
  (`flake.homeModules.git`, `flake.darwinModules.homebrew`).
- Feature flags: `features.<scope>.<name>.enable`.
- Host identifiers stay exact (`hex`, `LHQGQ5M2XX`).

### Packages and Programs

- Package lists: `with pkgs; [ ... ]` (repo convention).
- Prefer declarative `programs.<name>.enable = true;` over ad-hoc shell setup.
- Keep comments useful; explain intent, not syntax.

### Safety

- Gate optional config with `lib.mkIf cfg.enable`.
- Preserve `system.stateVersion` and `home.stateVersion` pins.
- Never commit plaintext secrets. Secrets are sops-encrypted
  (`.sops.yaml`, `modules/hosts/hex/secrets.yaml`).

## Agent Working Rules

- Add new functionality by creating a new file under the correct
  `modules/features/<scope>/` directory; it will be auto-discovered.
- Wire it into a host by adding `self.<scope>Modules.<name>` to that host's
  module list — do not edit `flake.nix`.
- Make minimal, scoped edits. Do not refactor unrelated files.
- If the worktree is dirty, do not revert unrelated user changes.
- Prefer targeted validation for the touched scope over full rebuilds.

## Suggested Validation by Change Type

- Home Manager (`modules/features/home-manager/**`, user HM profiles):
  1. `nixfmt <changed>` → 2. `statix check .` → 3. `deadnix .`
  4. `nix build .#darwinConfigurations.LHQGQ5M2XX.system --no-link`
     (and/or the NixOS build if `hex` consumes the module).
- NixOS (`modules/features/nixos/**`, `modules/hosts/hex/**`):
  1. `nixfmt <changed>` → 2. `statix check .` → 3. `deadnix .`
  4. `nix build .#nixosConfigurations.hex.config.system.build.toplevel --no-link`
- Darwin (`modules/features/darwin/**`, `modules/hosts/macbook-work/**`):
  1. `nixfmt <changed>` → 2. `statix check .` → 3. `deadnix .`
  4. `nix build .#darwinConfigurations.LHQGQ5M2XX.system --no-link`
