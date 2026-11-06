{ self, ... }:
{
  flake.homeModules.patrick-nixos =
    { pkgs, ... }:
    {
      features.home = {
        shell.enable = true;
        pdf.enable = true;
        neovim.enable = true;
        gpg = {
          enable = true;
          pinentryPackage = pkgs.pinentry-qt;
        };
        git = {
          enable = true;
          defaultIdentity = "personal";
          identities = {
            personal = {
              name = "Patrick Podbregar";
              email = "patrick.podbregar@proton.me";
              signingKey = "personal";
            };
            work = {
              name = "Patrick Podbregar";
              email = "patrick@example.com";
              signingKey = "work";
              remotes = [
                "git@github.com:example-org/**"
                "https://github.com/example-org/**"
              ];
            };
          };
        };
        network-tools.enable = true;
        agentic-coding.enable = true;
        obsidian.enable = true;
        nix-dev.enable = true;
        containers.enable = true;
        devtools.enable = true;
      };

      # These stylix targets emit deprecation warnings with the current inputs.
      stylix.targets = {
        rofi.enable = false;
        opencode.enable = false;
        # Must be disabled together with the NixOS qt target: on its own the
        # HM target falls back to qtct/kvantum, which breaks Plasma's QML shell.
        qt.enable = false;
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "vivaldi";
        TERMINAL = "ghostty";

        PAGER = "bat";

        # Tell man pages to use bat for syntax highlighting
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      };

      home.packages = with pkgs; [
        # Bitwarden password manager
        bitwarden-desktop
        # Commandline fuzzy finder
        gcc
        # GNU Make build tool
        gnumake
        # The python programming language
        python3
        # Rust toolchain installer
        rustup
        # Signal messenger
        signal-desktop
        # rar archive support
        unrar
        # archving tool
        peazip
        # Vivaldi browser
        # force-device-scale-factor=1 makes sure the browser is scale properly and does not appear huge on the screen.
        (vivaldi.override {
          commandLineArgs = "--ozone-platform=wayland --enable-features=useOzonePlatform,WaylandFractionalScaleV1 --force-device-scale-factor=1 --password-store=gnome";
        })
        # QView image viewer
        qview

        vlc
        nautilus
      ];
    };
}
