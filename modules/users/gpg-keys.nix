_: {
  # Key registry shared by all users. The matching armored secret keys live
  # in secrets/gpg.yaml under the same names.
  flake.homeModules.gpg-keys = {
    features.home.gpg.keys = {
      personal.fingerprint = "7B6994DFADD72A03ACDE008549470106DAA7CF3F";
      work.fingerprint = "FC238D4207B325C976E575B1FCDCBEA4DCACB487";
    };
  };
}
