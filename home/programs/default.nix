{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Bitwarden password manager
    bitwarden-desktop
    # Commandline fuzzy finder
    fzf
    # GNU C Compiler
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
    # Faster grep replacement (rg)
    ripgrep
    # Rust toolchain installer
    rustup
    # Signal messenger
    signal-desktop
    # Nix linter
    statix
    # Lua code formatter
    stylua
    # Tool to produce a depth indented directory listing
    tree
    # extraction utility for zip files
    unzip
    # Vivaldi browser
    vivaldi
    # Tool for retrieving files via http or ftp
    wget
  ];

  programs = {

    git = {
      enable = true;
      settings = {
        user = {
          name = "Patrick Podbregar";
          email = "patrick.podbregar@proton.me";
        };
      };
    };
  };
}
