{ self, ... }:
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
        ];

        features.home = {
          git = {
            enable = true;
            userName = "Patrick Podbregar";
            userEmail = "patrick.podbregar@bearingpoint.com";
          };

          shell.enable = true;
          neovim.enable = true;
          nix-dev.enable = true;
          containers.enable = true;
          devtools.enable = true;
          node-dev.enable = true;
          markdown-dev.enable = true;
          python-dev.enable = true;
          java-dev.enable = true;
          agentic-coding.enable = true;
        };

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
