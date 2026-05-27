{ self, inputs, ...} : {
  flake.homeModules.neovim = {pkgs,...}:{

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      
      extraPackages = with pkgs; [
        lua
        lua52Packages.luarocks
        ripgrep
        fd
        gcc
        gnumake
        unzip
        wget
        curl
        tree-sitter
        nodejs_20
        imagemagick
      ];

      # This is done for compatibility with newer home-manager versions
      withRuby = false;
      withPython3 = true;
    };

    # Link my neovim config to default config location
    xdg.configFile."nvim".source = inputs.nvim-config;
  };
}
