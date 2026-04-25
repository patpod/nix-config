{ self, inputs, ... }:
{
  flake.nixosModules.patrick =
    {
      config,
      pkgs,
      ...
    }:
    let
      username = "patrick";
    in
    {
      imports = [
        inputs.self.nixosModules.home-manager
      ];

      # Enable zsh on system level to make it the default login shell
      programs.zsh.enable = true;

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
          inputs.self.homeModules.patrick
          inputs.self.homeModules.niri
        ];
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";

        # NixOS specific packages
        home.packages = with pkgs; [
          vlc
          nautilus
        ];

      };
    };
}
