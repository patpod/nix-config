{ self, inputs, ... }:
{
  flake.homeModules.shell =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.zsh
        self.homeModules.ghostty
        self.homeModules.tmux
        self.homeModules.oh-my-posh
      ];

      my.programs.ghostty.enable = true;

      home.packages = with pkgs; [
        # Commandline fuzzy finder
        fzf
        # Rust toolchain installer
        tree
        # extraction utility for zip files
        unzip
        # Tool for retrieving files via http or ftp
        wget
        # Command line tool for transferring files with URL syntax
        curl
        # Better find
        fd
        # Modern ps replacement
        procs
      ];

      # Modern ls replacement
      programs.eza = {
        enable = true;
        enableZshIntegration = true;
        icons = "auto";
        git = true;
      };

      # Modern alternative for cat
      programs.bat = {
        enable = true;
      };

      # Modern top replacement
      programs.btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
          update_ms = 1000;
        };
      };

      # Faster grep
      programs.ripgrep.enable = true;

      # Commandline json and yaml parser
      programs.jq.enable = true;

      # man replacement
      programs.tealdeer = {
        enable = true;
        settings.display.compact = false;
        settings.auto_update = true;
      };

      # Commandline file browser
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        shellWrapperName = "y";
      };
    };
}
