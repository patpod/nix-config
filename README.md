# nix-config

Nix flake configuration for the NixOS host `hex` and the nix-darwin host
`LHQGQ5M2XX`. See `AGENTS.md` for the module layout (dendritic pattern).

## Git commit signing with GPG

Git identities are selected by the **remote URL** of a repository. Each identity
can sign with its own GPG key. The secret keys are stored encrypted with sops
in `modules/users/secrets/gpg.yaml` and are imported into the local keyring
whenever Home Manager activates (on NixOS and on macOS alike). The decrypted
key is piped straight into `gpg` and never written to disk.

The pieces:

| What | Where |
|---|---|
| Key registry (name → fingerprint), shared by all users | `modules/users/gpg-keys.nix` |
| Encrypted secret keys | `modules/users/secrets/gpg.yaml` |
| Identities (name, email, key, remotes) | `features.home.git` in the user files `modules/users/nixos/patrick/home.nix` and `modules/users/darwin/patrick-be/default.nix` |
| GPG module (agent, key import) | `modules/features/home-manager/gpg.nix` |

### Prerequisite: age key

sops decrypts with your personal age key. Copy it over before the first
rebuild; if it is missing, activation prints a warning and skips the key
import.

sops resolves the default age key location through the OS config directory, so
the path differs per platform:

| Platform | Default location |
|---|---|
| NixOS | `~/.config/sops/age/keys.txt` |
| macOS | `~/Library/Application Support/sops/age/keys.txt` |

On macOS, `~/.config/sops/age/keys.txt` is **not** consulted by default (sops
only uses it when `XDG_CONFIG_HOME` is set). Either place the key at the
default path above:

```sh
mkdir -p "$HOME/Library/Application Support/sops/age"
chmod 700 "$HOME/Library/Application Support/sops/age"
mv <the-age-key> "$HOME/Library/Application Support/sops/age/keys.txt"
chmod 600 "$HOME/Library/Application Support/sops/age/keys.txt"
```

or keep it under `~/.config` and export the path explicitly:

```sh
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
```

The Home Manager GPG module always exports `SOPS_AGE_KEY_FILE` before calling
sops, so activation works regardless of the platform default.

### Add a new GPG key

1. Export the secret key:

   ```sh
   gpg --armor --export-secret-keys <fingerprint>
   ```

2. Add it to the encrypted file under a short name (for example `client-x`):

   ```sh
   sops modules/users/secrets/gpg.yaml
   ```

   ```yaml
   client-x: |
     -----BEGIN PGP PRIVATE KEY BLOCK-----
     ...
   ```

3. Register the fingerprint (full 40 characters, no spaces) in
   `modules/users/gpg-keys.nix`:

   ```nix
   client-x.fingerprint = "ABCD...";
   ```

4. Create an identity that uses it, in the user file of each machine where it
   should apply:

   ```nix
   features.home.git.identities.client-x = {
     name = "Patrick Podbregar";
     email = "patrick@client-x.com";
     signingKey = "client-x";
     remotes = [
       "git@github.com:client-x/**"
       "https://github.com/client-x/**"
     ];
   };
   ```

5. Rebuild:

   ```sh
   sudo nixos-rebuild switch --flake .#hex        # NixOS
   darwin-rebuild switch --flake .#LHQGQ5M2XX     # macOS
   ```

`defaultIdentity` is used for all repositories that match no `remotes` entry.
Set `signingKey = null` on an identity to disable signing for it.

### Change or rotate a key

Replace the block in `modules/users/secrets/gpg.yaml` and the fingerprint in
`modules/users/gpg-keys.nix`, then rebuild. The old key stays in the keyring
until you remove it with `gpg --delete-secret-keys <fingerprint>`.

### Verify

```sh
git -C <repo> config user.email
git -C <repo> commit --allow-empty -m "test signing"
git -C <repo> log --show-signature -1
```

Remember to add the **public** key to your git host (for example GitHub →
Settings → SSH and GPG keys).

### Notes

- Remote patterns use git's `hasconfig:remote.*.url:` conditional include
  (git 2.36 or newer). Patterns are globs, so `**` matches everything after the
  prefix. Repositories without a remote use the default identity.
- GPG is managed by Nix on both machines. The Homebrew `gpg-suite` cask was
  removed because it would conflict with the Home Manager managed `gpg-agent`.
- Placeholder `remotes` patterns in the repo (`example-user`, `example-org`)
  must be replaced with real ones. The fingerprints in
  `modules/users/gpg-keys.nix` are real: `personal`
  (`patrick.podbregar@proton.me`) and `work`
  (`patrick.podbregar@bearingpoint.com`).
