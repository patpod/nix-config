{ self, inputs, ... }:
{

  flake.darwinModules.config =
    { pkgs, config, ... }:
    {

      nixpkgs.config.allowUnfree = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable zsh on system level to make it the default login shell
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.primaryUser = "patrick.podbregar";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
}
