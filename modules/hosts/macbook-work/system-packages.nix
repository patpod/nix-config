_: {
  flake.darwinModules.sysPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        # GNU coreutils - the ones that come with MacOS are outdated
        pkgs.coreutils
        # GNU implementation of the grep command (installed on mac for
        # compatibility in scripts)
        pkgs.gnugrep
      ];
    };
}
