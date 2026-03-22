{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sddm-astronaut
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
    wayland.enable = true;
    settings = {
      General = {
        EnableHiDPI = true;
      };
    };
  };
}
