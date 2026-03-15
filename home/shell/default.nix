{ config, ... }:
{
  # imports = [
  #   ./zsh.nix
  # ];

  home.sessionVariables = {
    # set default applications
    EDITOR = "nvim";
    BROWSER = "vivaldi";
    TERMINAL = "ghostty";
  };
}
