_: {
  # Key registry shared by all users. The matching armored secret keys live
  # in secrets/gpg.yaml under the same names.
  flake.homeModules.gpg-keys = {
    features.home.gpg.keys = {
      personal.fingerprint = "0000000000000000000000000000000000000000";
      work.fingerprint = "1111111111111111111111111111111111111111";
    };
  };
}
