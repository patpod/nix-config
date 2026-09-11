{
  flake.nixosModules.hexFingerprintReader =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      systemctl = "${config.systemd.package}/bin/systemctl";
    in
    {
      # The Goodix sensor of this Framework laptop does not survive a
      # suspend/resume cycle. Two things break independently from each other:
      #
      #   1. fprintd keeps a USB handle that is dead after resume. The daemon
      #      still lists the device, but every verification against it fails.
      #   2. The KDE lock screen greeter survives the suspend and keeps its PAM
      #      conversation open against the *old* fprintd, so even a healthy
      #      daemon never gets asked for a fingerprint.
      #
      # Release the device before going to sleep and rebuild both ends on
      # resume.
      config = lib.mkIf config.services.fprintd.enable {
        systemd.services = {
          fprintd-suspend = {
            description = "Release the fingerprint reader before sleep";
            before = [ "sleep.target" ];
            wantedBy = [ "sleep.target" ];
            serviceConfig = {
              Type = "oneshot";
              # Unlike `killall fprintd` this also succeeds when the daemon is
              # not running, which is the usual case because it is activated
              # on demand via D-Bus.
              ExecStart = "${systemctl} stop fprintd.service";
            };
          };

          fprintd-resume = {
            description = "Reinitialize the fingerprint reader after resume";
            after = [
              "suspend.target"
              "hibernate.target"
              "hybrid-sleep.target"
              "suspend-then-hibernate.target"
            ];
            wantedBy = [
              "suspend.target"
              "hibernate.target"
              "hybrid-sleep.target"
              "suspend-then-hibernate.target"
            ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = pkgs.writeShellScript "fprintd-resume" ''
                # Rebind the daemon to the re-enumerated USB device. This is a
                # no-op while fprintd is stopped, D-Bus then activates a fresh
                # one on the next authentication attempt.
                ${systemctl} try-restart fprintd.service

                # Drop the stale lock screen greeter. kscreenlocker respawns it
                # right away, so the session stays locked and the new greeter
                # opens a fresh PAM conversation with the restarted daemon.
                # Matching on the command line is required because the process
                # name is truncated to 15 characters.
                ${pkgs.procps}/bin/pkill -f kscreenlocker_greet || true
              '';
            };
          };
        };
      };
    };
}
