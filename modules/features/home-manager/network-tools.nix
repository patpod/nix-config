{ ... }:
{
  flake.homeModules.network-tools =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.network-tools;
    in
    {
      options.features.home.network-tools = {
        enable = lib.mkEnableOption "useful network diagnostic and monitoring tools";
      };

      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          # DNS utilities (provides dig, nslookup, host)
          bind

          # HTTP and file transfer utilities
          curl
          wget

          # Network exploration and security auditing
          nmap

          # Advanced traceroute and ping (combines functionality of both)
          mtr

          # Command-line packet analyzer
          tcpdump

          # Bandwidth and network performance measurement
          iperf3

          # Domain whois lookup
          whois

          # Multipurpose relays (listen, connect, forward)
          socat
          netcat-gnu

          # Modern Rust-based alternatives (optional but highly recommended)
          doggo # Modern DNS client (like dig)
          bandwhich # Terminal bandwidth utilization tool
          trippy # Network diagnostic tool (modern mtr)
        ];
      };
    };
}
