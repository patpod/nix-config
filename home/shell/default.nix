{ config, ... }:
{
  imports = [
    ./terminals.nix
    ./zsh.nix
    ./ohmyposh
    ./tmux.nix
  ];

  home.sessionVariables = {
    # set default applications
    EDITOR = "nvim";
    BROWSER = "vivaldi";
    TERMINAL = "ghostty";
  };
}
