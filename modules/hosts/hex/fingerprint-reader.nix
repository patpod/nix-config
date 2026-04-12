{
  flake.nixosModules.hexFingerprintReader =
    { pkgs, ... }:
    {

      # Fix the Framework/fprintd suspend bug by killing it right before sleep
      systemd.services.fprintd-suspend-fix = {
        description = "Kill fprintd before sleep to fix suspend lockup";
        before = [ "sleep.target" ];
        wantedBy = [ "sleep.target" ];
        serviceConfig = {
          Type = "oneshot";
          # psmisc provides the killall command
          ExecStart = "${pkgs.psmisc}/bin/killall fprintd";
        };
      };
    };
}
