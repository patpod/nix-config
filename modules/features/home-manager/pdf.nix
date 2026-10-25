_: {
  flake.homeModules.pdf =
    { config, lib, ... }:
    let
      cfg = config.features.home.pdf;
    in
    {
      options.features.home.pdf = {
        enable = lib.mkEnableOption "PDF viewing and editing";
      };

      config = lib.mkIf cfg.enable {
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
    };
}
