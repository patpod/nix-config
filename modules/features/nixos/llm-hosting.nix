_: {
  flake.nixosModules.llm-hosting =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.nixos.llm-hosting;
    in
    {
      options.features.nixos.llm-hosting = {
        enable = lib.mkEnableOption "Enable llm-hosting capabilities";
      };

      config = lib.mkIf cfg.enable {
        services.ollama = {
          enable = true;
          package = pkgs.ollama-vulkan;
        };

        services.open-webui = {
          enable = true;
          port = 8080;

          environment = {
            OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
            WEBUI_AUTH = "False";

            # Disable telemetry
            ANONYMIZED_TELEMETRY = "False";
            DO_NOT_TRACK = "True";
            SCARF_NO_ANALYTICS = "True";
          };
        };
      };
    };
}
