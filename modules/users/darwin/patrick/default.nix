{ self, ... }:
{

  flake.darwinModules.patrick =
    let
      username = "patrick.podbregar";
    in
    { pkgs, lib, ... }:
    {
      users.users."${username}" = {
        name = "${username}";
        home = "/Users/${username}";
      };

      home-manager.users."${username}" = {

        imports = [
          self.homeModules.darwin
          self.homeModules.shell
          self.homeModules.neovim
          self.homeModules.git
          self.homeModules.obsidian
          self.homeModules.nix-dev
          self.homeModules.containers
          self.homeModules.devtools
        ];

        features.home.git = {
          enable = true;
          userName = "Patrick Podbregar";
          userEmail = "patrick.podbregar@bearingpoint.com";
        };

        features.home.nix-dev.enable = true;
        features.home.containers.enable = true;
        features.home.devtools.enable = true;

        home.packages = with pkgs; [
          stow
        ];

        # NOTE: `home.sessionPath` is exported in
        # ~/.nix-profile/etc/profile.d/hm-session-vars.sh, which is sourced from
        # .zprofile/.zshenv. On macOS that runs *before* /etc/zprofile, which
        # invokes /usr/libexec/path_helper and rebuilds PATH from scratch —
        # dropping any prepended entries. Re-prepending in zsh's interactive
        # init guarantees ~/.local/bin survives path_helper.
        home.sessionPath = [
          "$HOME/.local/bin"
        ];

        programs.zsh.initContent = lib.mkAfter ''
          # Re-prepend HM sessionPath entries after macOS path_helper has run.
          export PATH="$HOME/.local/bin:$PATH"
        '';

        home.stateVersion = "25.11";

        # Let Home Manager install and manage itself
        programs.home-manager.enable = true;
      };
    };
}
