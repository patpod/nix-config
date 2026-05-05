{ self, inputs, ... }:
{
  flake.homeModules.pdf = {
    programs.zathura = {
      enable = true;

      options = {
        backend = "mupdf";

        guioptions = "none";
        statusbar-home-ttl = true;
        scroll-step = 50;
        selection-clipboard = "clipboard";

        page-store-threshold = 4;
        pages-per-row = 2;
        first-page-column = 1;
      };
    };
  };
}
