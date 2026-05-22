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
        ];

        home.stateVersion = "25.11";

        # Let Home Manager install and manage itself
        programs.home-manager.enable = true;
      };
  };
}
