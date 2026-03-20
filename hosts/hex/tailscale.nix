{ config, pkgs, ... }:
{
  services.tailscale.enable = true;

  # Open the default Tailscale port if you want to assist in
  # direct connections (optional but recommended)
  networking.firewall.allowedUDPPorts = [ 41641 ];

  # Standard Tailscale setup often requires allowing the
  # virtual network interface
  networking.firewall.checkReversePath = "loose";

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";

    script = ''
      # Wait for the tailscale socket to be ready
      sleep 2

      #Check current status
      status=$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)
      if [ "$status" = "Running" ]; then
        exit 0
      fi

      # Read the key from the sops secret path
      AUTH_KEY=$(cat ${config.sops.secrets.tailscaleAuthKey.path})

      # Run tailscale up
      ${pkgs.tailscale}/bin/tailscale up --authkey "$AUTH_KEY"
    '';
  };

  environment.systemPackages = [
    pkgs.jq
    pkgs.tailscale
  ];
}
