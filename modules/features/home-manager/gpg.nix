_: {

  flake.homeModules.gpg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.gpg;
      gpg = lib.getExe config.programs.gpg.package;
      sops = lib.getExe pkgs.sops;

      importKey = name: key: ''
        if ! ${gpg} --list-secret-keys ${key.fingerprint} >/dev/null 2>&1; then
          if ${sops} -d --extract '["${name}"]' ${cfg.secretKeysFile} | ${gpg} --batch --quiet --import; then
            echo "${key.fingerprint}:6:" | ${gpg} --batch --import-ownertrust
          else
            echo "gpg: could not import key '${name}' (${key.fingerprint}) from sops" >&2
          fi
        fi
      '';
    in
    {
      options.features.home.gpg = {
        enable = lib.mkEnableOption "GnuPG with sops-managed secret keys";

        pinentryPackage = lib.mkOption {
          type = lib.types.package;
          description = "Pinentry package used by gpg-agent to ask for passphrases.";
        };

        secretKeysFile = lib.mkOption {
          type = lib.types.path;
          default = ../../users/secrets/gpg.yaml;
          description = ''
            sops-encrypted YAML file holding the armored secret keys. Every
            entry in `keys` must have a top-level entry with the same name.
          '';
        };

        ageKeyFile = lib.mkOption {
          type = lib.types.str;
          default = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
          description = "age identity used to decrypt `secretKeysFile`.";
        };

        keys = lib.mkOption {
          default = { };
          description = ''
            Registry of GPG signing keys, keyed by the name of their entry in
            `secretKeysFile`. Git identities refer to these names.
          '';
          type = lib.types.attrsOf (
            lib.types.submodule {
              options.fingerprint = lib.mkOption {
                type = lib.types.str;
                description = "Full 40 character fingerprint of the key.";
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable {
        programs.gpg.enable = true;

        services.gpg-agent = {
          enable = true;
          defaultCacheTtl = 3600;
          maxCacheTtl = 28800;
          pinentry.package = cfg.pinentryPackage;
        };

        # Decrypt the keys straight into gpg so they never touch the disk.
        home.activation.importGpgKeys = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          if [[ ! -v DRY_RUN ]]; then
            export GNUPGHOME=${lib.escapeShellArg config.programs.gpg.homedir}
            export SOPS_AGE_KEY_FILE=${lib.escapeShellArg cfg.ageKeyFile}
            if [[ -f "$SOPS_AGE_KEY_FILE" ]]; then
              ${lib.concatStringsSep "\n" (lib.mapAttrsToList importKey cfg.keys)}
            else
              echo "gpg: age key $SOPS_AGE_KEY_FILE not found, skipping key import" >&2
            fi
          fi
        '';
      };
    };
}
