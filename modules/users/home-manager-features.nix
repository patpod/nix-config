{ self, ... }: {
  flake.homeModules.features = {
    imports = [
      self.homeModules.shell
      self.homeModules.pdf
      self.homeModules.neovim
      self.homeModules.gpg
      self.homeModules.gpg-keys
      self.homeModules.git
      self.homeModules.obsidian
      self.homeModules.nix-dev
      self.homeModules.containers
      self.homeModules.devtools
      self.homeModules.node-dev
      self.homeModules.markdown-dev
      self.homeModules.python-dev
      self.homeModules.java-dev
      self.homeModules.network-tools
      self.homeModules.agentic-coding
    ];
  };
}
