{self, inputs, ...}: {

  flake.darwinModules.patrick =
    let
      username = "patrick.podbregar";
    in
    {pkgs, ...} :
    {
      users.users."${username}" = {
        name = "${username}";
        home = "/Users/${username}";
      };

      home-manager.users."${username}" = {

        imports = [
          self.homeModules.shell
          self.homeModules.neovim
          self.homeModules.git
        ];

        features.home.git = {
          enable = true;
          userName = "Patrick Podbregar";
          userEmail = "patrick.podbregar@bearingpoint.com";
        };


        home.packages = with pkgs; [
          stow
        ];

        home.stateVersion = "25.11";

        # Let Home Manager install and manage itself
        programs.home-manager.enable = true;
      };
  };
}
