{ pkgs, ... }:
{
  services.tailscale.enable = true;

  # Open the default Tailscale port if you want to assist in
  # direct connections (optional but recommended)
  networking.firewall.allowedUDPPorts = [ 41641 ];

  # Standard Tailscale setup often requires allowing the
  # virtual network interface
  networking.firewall.checkReversePath = "loose";
}
