{ inputs, ... }:
{

  flake.homeModules.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.features.home.git;
    in
    {
      imports = [
        inputs.hunk.homeManagerModules.default
      ];

      options.features.home.git = {
        enable = lib.mkEnableOption "git configuration and companion tools";

        defaultIdentity = lib.mkOption {
          type = lib.types.str;
          description = "Name of the identity used when no identity matches a repository.";
        };

        identities = lib.mkOption {
          default = { };
          description = ''
            Git identities. The default identity is used globally; the others
            override it in repositories with a matching remote URL.
          '';
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name to use for git commits.";
                };

                email = lib.mkOption {
                  type = lib.types.str;
                  description = "Email to use for git commits.";
                };

                signingKey = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Name of a key in `features.home.gpg.keys` used to sign
                    commits. Null disables signing for this identity.
                  '';
                };

                remotes = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  example = [
                    "git@github.com:my-org/**"
                    "https://github.com/my-org/**"
                  ];
                  description = ''
                    Remote URL patterns (git `hasconfig:remote.*.url:` globs)
                    that select this identity.
                  '';
                };
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable (
        let
          gpgKeys = config.features.home.gpg.keys;
          fingerprintOf = id: if id.signingKey == null then null else gpgKeys.${id.signingKey}.fingerprint;
          defaultId = cfg.identities.${cfg.defaultIdentity};
          defaultFingerprint = fingerprintOf defaultId;

          identityConfig =
            id:
            let
              fingerprint = fingerprintOf id;
            in
            {
              user = {
                inherit (id) name email;
              }
              // lib.optionalAttrs (fingerprint != null) { signingKey = fingerprint; };
              commit.gpgSign = fingerprint != null;
              tag.gpgSign = fingerprint != null;
            };

          identityIncludes = lib.concatMap (
            id:
            map (remote: {
              condition = "hasconfig:remote.*.url:${remote}";
              contents = identityConfig id;
            }) id.remotes
          ) (lib.attrValues (lib.filterAttrs (n: _: n != cfg.defaultIdentity) cfg.identities));
        in
        {
          assertions = [
            {
              assertion = lib.hasAttr cfg.defaultIdentity cfg.identities;
              message = "features.home.git.defaultIdentity '${cfg.defaultIdentity}' is not in features.home.git.identities.";
            }
          ]
          ++ lib.mapAttrsToList (name: id: {
            assertion = id.signingKey == null || lib.hasAttr id.signingKey gpgKeys;
            message = "Git identity '${name}' uses unknown signing key '${id.signingKey}'; add it to features.home.gpg.keys.";
          }) cfg.identities;

          programs.git = {
            enable = true;

            lfs.enable = true;

            signing = lib.mkIf (defaultFingerprint != null) {
              format = "openpgp";
              key = defaultFingerprint;
              signByDefault = true;
            };

            includes = identityIncludes;

            settings = {
              user = {
                inherit (defaultId) name email;
              };

              init.defaultBranch = "master";
              pull.rebase = true;
              push.autoSetupRemote = true;
              core.editor = "nvim";
            };
          };

          programs.delta.enable = true;

          programs.lazygit = {
            enable = true;
            enableZshIntegration = true;
            settings = {
              showGraph = "always";
            };
          };

          programs.hunk = {
            enable = true;
            enableGitIntegration = true;

            settings = {
              mode = "split";
              line_numbers = true;
            };
          };

          home.packages = with pkgs; [
            github-cli
            gh-token
            # Git graph visualization
            serie
          ];
        }
      );
    };
}
