{ self, inputs, ... }:
{
  flake.nixosModules.bluetooth = {

    # Enable proprietary firmware
    hardware.enableAllFirmware = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      # Enable battery reporting for wireless headphones
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    # Bluetooth control from within niri
    services.blueman.enable = true;

  };
}
