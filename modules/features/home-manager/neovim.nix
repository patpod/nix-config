{ self, inputs, ... }:
{
  flake.homeModules.neovim =
    { pkgs, ... }:
    {

      programs.neovim = {
        enable = true;
        defaultEditor = true;

        extraPackages = with pkgs; [
          # The Lua programming language (5.1 because that's what neovim wants)
          lua5_1
          # Lua package manager
          lua51Packages.luarocks
          # Lua code formatter
          stylua
          ripgrep
          fd
          gcc
          gnumake
          unzip
          wget
          curl
          tree-sitter
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
