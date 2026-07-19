{ self, ... }:
{
  flake.homeModules.patrick-nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        self.homeModules.shell
        self.homeModules.pdf
        self.homeModules.niri
        self.homeModules.neovim
        self.homeModules.git
        self.homeModules.obsidian
        self.homeModules.nix-dev
      ];

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
