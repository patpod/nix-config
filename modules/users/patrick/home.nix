{ self, ... }:
{
  flake.homeModules.patrick =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        self.homeModules.shell
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
        # age ecryption tool
        age
        # Bitwarden password manager
        bitwarden-desktop
        # Commandline fuzzy finder
        gcc
        # GNU Make build tool
        gnumake
        # lazygit Git TUI
        lazygit
        # The Lua programming language (5.1 because that's what neovim wants)
        lua5_1
        # Lua package manager
        lua51Packages.luarocks
        # God's chosen text editor
        neovim
        # Nix formatter
        nixfmt
        # The python programming language
        python3
        # Rust toolchain installer
        rustup
        # Signal messenger
        signal-desktop
        # SOPS secret management
        sops
        # Nix linter
        statix
        # Lua code formatter
        stylua
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
      ];

      home.stateVersion = "25.11";
    };
}
