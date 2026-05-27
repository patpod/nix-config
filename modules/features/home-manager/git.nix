{ self, inputs, ...} : {
  
  flake.homeModules.git = { config, lib, pkgs, ...}:
  let
    cfg = config.features.home.git;  
  in
  {
    options.features.home.git = {
      enable = lib.mkEnableOption "git configuration and companion tools";
    
      userName = lib.mkOption {
        type = lib.types.str;
        default = "Username"; # Assumed from your folder structure
        description = "The main name to use for git commits.";
      };
      
      userEmail = lib.mkOption {
        type = lib.types.str;
        default = "user@example.com"; # Replace with your default!
        description = "The email to use for git commits.";
      };
    };

    config = lib.mkIf cfg.enable {
      programs.git = {
        enable = true;

        lfs.enable = true;

        settings = {
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };

          init.defaultBranch = "master";
          pull.rebase = true;
          push.autoSetupRemote = true;
          core.editor = "nvim";
        };

      };

      programs.delta.enable = true;

      programs.lazygit = {
        enable = true;
        enableZshIntegration = true;
      };
      
      home.packages = with pkgs; [
      ];
    };
  };
}
