{ self, inputs, ... }:
{
  flake.homeModules.containers =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.containers;
    in
    {
      options.features.home.containers = {
        enable = lib.mkEnableOption "OCI container tooling for local development";
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          with pkgs;
          [
            # docker-compose-compatible orchestration for podman
            podman-compose
            # Copy, inspect and sign images across registries — fully daemonless
            skopeo
            # Explore image layers and hunt down wasted space
            dive
            # TUI dashboard for containers/images (talks to the podman socket)
            lazydocker
          ]
          # buildah builds Linux containers using Linux namespaces, so it only
          # exists on Linux. On macOS you build inside the podman machine with
          # `podman build` instead.
          ++ lib.optionals pkgs.stdenv.isLinux [
            buildah
          ];
      };
    };
}
