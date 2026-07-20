{ config, lib, ... }: {

  flake.darwinModules.netscope =
    { config, pkgs, ... }:
    let
      cfg = config.features.darwin.netscope;
    in
    {
      options.features.darwin.netscope = {
        enable = lib.mkEnableOption "Setttings to make MacOS work with Netscope";

        caFile = lib.mkOption {
          type = lib.types.path;
          default = ../../../assets/certs/ca.bearingpoint.goskope.com.pem;
          description = ''
            Path to the Netskope root CA in PEM format. Defaults to the copy
            committed alongside this module.
          '';
        };
      };

      config = lib.mkIf cfg.enable (
        let
          # A combined bundle = upstream Mozilla roots + Netskope root.
          # Built reproducibly inside /nix/store, so no manual /etc/nix file needed.
          nixCaBundle = pkgs.runCommand "nix-ca-bundle.crt" { } ''
            cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ${cfg.caFile} > $out
          '';
        in
        {
          # 1. Make the system trust the corp root (rebuilds pkgs.cacert with it included)
          security.pki.certificateFiles = [ cfg.caFile ];

          # 2. Point Nix (client + daemon) at the combined bundle
          nix.settings.ssl-cert-file = "${nixCaBundle}";

          # 3. Make every tool that respects the standard env var see it too
          environment.variables = {
            NIX_SSL_CERT_FILE = "${nixCaBundle}";
            SSL_CERT_FILE = "${nixCaBundle}";
            # Common per-ecosystem overrides that ignore SSL_CERT_FILE:
            NODE_EXTRA_CA_CERTS = "${cfg.caFile}";
            REQUESTS_CA_BUNDLE = "${nixCaBundle}";
            CARGO_HTTP_CAINFO = "${nixCaBundle}";
            GIT_SSL_CAINFO = "${nixCaBundle}";
          };

          # 4. Make sure the launchd-managed nix-daemon gets it too on macOS
          launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables = {
            NIX_SSL_CERT_FILE = "${nixCaBundle}";
          };
        }
      );
    };
}
