{ config, ... }:
{
  home.file."${config.xdg.configHome}/ohmyposh/zen.omp.toml".source = ./themes/zen.omp.toml;

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;

    configFile = "${config.xdg.configHome}/ohmyposh/zen.omp.toml";
  };
}
