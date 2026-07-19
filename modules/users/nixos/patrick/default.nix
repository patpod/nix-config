{ self, inputs, ... }:
{
  flake.nixosModules.patrick =
    let
      username = "patrick";
    in
    { pkgs, ... }:
    {
      users.users."${username}" = {
        isNormalUser = true;
        description = "Patrick Podbregar";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
      };

      home-manager.users."${username}" = {
        imports = [
          inputs.self.homeModules.nixos-common
          inputs.self.homeModules.patrick-nixos
        ];
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";

      };
    };
}
