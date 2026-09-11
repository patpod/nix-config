_: {
  flake.nixosModules.video-editing =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.nixos.video-editing;
    in
    {
      options.features.nixos.video-editing = {
        enable = lib.mkEnableOption "Video editing tools";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
          kdePackages.kdenlive
          # Useful for proxy generation and accelerated rendering
          mediainfo
          ffmpeg-full
        ];
      };
    };
}
