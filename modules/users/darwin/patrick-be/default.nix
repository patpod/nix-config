{ self, inputs, ... }:
{
  flake.darwinModules.patrick-be =
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
          self.homeModules.darwin-common
          self.homeModules.shell
          self.homeModules.neovim
          self.homeModules.git
          self.homeModules.obsidian
          self.homeModules.nix-dev
          self.homeModules.containers
          self.homeModules.devtools
          self.homeModules.node-dev
          self.homeModules.markdown-dev
          self.homeModules.python-dev
          self.homeModules.java-dev
        ];

        features.home.git = {
          enable = true;
          userName = "Patrick Podbregar";
          userEmail = "patrick.podbregar@bearingpoint.com";
        };

        features.home.nix-dev.enable = true;
        features.home.containers.enable = true;
        features.home.devtools.enable = true;
        features.home.node-dev.enable = true;
        features.home.markdown-dev.enable = true;
        features.home.python-dev.enable = true;
        features.home.java-dev.enable = true;

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
      };
    };
}
