{ self, inputs, ... }:
{
  flake.darwinModules.patrick-be =
    let
      username = "patrick.podbregar";
    in
    { pkgs, ... }:
    {
      users.users."${username}" = {
        name = "${username}";
        home = "/Users/${username}";
      };

      home-manager.users."${username}" = {

        imports = [
          self.homeModules.darwin-common
          self.homeModules.shell
          self.homeModules.neovim
          self.homeModules.git
          self.homeModules.obsidian
          self.homeModules.nix-dev
        ];

        features.home.git = {
          enable = true;
          userName = "Patrick Podbregar";
          userEmail = "patrick.podbregar@bearingpoint.com";
        };

        features.home.nix-dev.enable = true;

        home.packages = with pkgs; [
          stow
        ];
      };
    };
}
