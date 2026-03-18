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

  # --- Terminal tools ---
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
}
