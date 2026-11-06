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
          gpg = {
            enable = true;
            pinentryPackage = pkgs.pinentry_mac;
          };

          git = {
            enable = true;
            defaultIdentity = "work";
            identities = {
              work = {
                name = "Patrick Podbregar";
                email = "patrick.podbregar@bearingpoint.com";
                signingKey = "work";
              };
              personal = {
                name = "Patrick Podbregar";
                email = "patrick.podbregar@proton.me";
                signingKey = "personal";
                remotes = [
                  "git@github.com:patpod/**"
                  "https://github.com/patpod/**"
                ];
              };
            };
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

        # Stylix's opencode target writes `programs.opencode.tui`, which
        # OpenCode 2 ignores (it reads a single `cli.json`), producing a
        # warning on every evaluation. Disabled here for the same reason as in
        # the NixOS profile; re-enable once stylix targets OpenCode 2.
        stylix.targets.opencode.enable = false;

        # The rofi target sets `programs.rofi.font`, which Home Manager renamed
        # to `programs.rofi.settings.font`, so stylix emits a deprecation
        # warning. rofi is an X11 launcher and unused on macOS.
        stylix.targets.rofi.enable = false;

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
