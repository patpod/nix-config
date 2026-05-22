{ self, inputs, ...}: {

  flake.darwinModules.sysPackages = {pkgs, ...} : {

    environment.systemPackages = [
      # Aerospace - tiling window manager
      # pkgs.aerospace
      # age - encryption tool
      # pkgs.age
      # Ansible - Configuration management tool
      pkgs.ansible
      # Azure CLI - Next generation multi-platform command line experience for Azure
      pkgs.azure-cli
      # bat - a cat clone with syntax higlighting and git integration
      # pkgs.bat
      # bruno - Open Source IDE for exploring and testing APIs
      # pkgs.bruno
      # bun - Javascript/Typescript runtime
      # pkgs.bun
      # Rust build tool
      # pkgs.cargo
      # GNU coreutils - the ones that come with MacOS are outdated
      # pkgs.coreutils
      # difftastic - sytax aware diff tool
      # pkgs.difftastic
      # d2 - diagram scripting language
      # pkgs.d2
      # eza - a modern ls replacement
      # pkgs.eza
      # Feh lightweight image viewer
      # Used for displaying PlantUML diagrams
      # pkgs.feh
      # Simple, fast and user-friendly alternative to find
      # pkgs.fd
      # GNU find utils
      # pkgs.findutils
      # Fast Node Manager - Fast and simple Node.js version manager
      # pkgs.fnm
      # fzf - Command-line fuzzy finder
      # pkgs.fzf
      # Garage object store - used for the included cli
      # pkgs.garage_2
      # Ghostty Terminal Emulator
      # This package in version 1.1.3 is currently broken. For now I use homebrew.
      # pkgs.ghostty
      # Git - Distributed version control tool
      # pkgs.git
      # Git extension for versioning large files
      # pkgs.git-lfs
      # gitmux - Git in tmux status bar
      # pkgs.gitmux
      # GNU Privacy Guard
      # e.g., used to sign git commits
      # pkgs.gnupg
      # GNU implementation of the grep command (installed on mac for compatibility in scipts)
      # pkgs.gnugrep
      # Google Cloud SDK - GCP command line utilities
      # pkgs.google-cloud-sdk
      # Go programming language
      # pkgs.go
      # Software suite to create, edit, compose, or convert bitmap images
      # Needed for some Neovim plugins
      # pkgs.imagemagick
      # JankyBorders - Tool to make the active window on MacOS more visible
      # pkgs.jankyborders
      # jq commandline JSON parser
      # pkgs.jq
      # kubectl - kubernetes CLI
      # pkgs.kubectl
      # Fast way to switch between clusters and namespaces in kubectl
      # pkgs.kubectx
      # Kubernetes credential plugin implementing Azure authentication
      # pkgs.kubelogin
      # Helm - Package manager for Kubernetes
      # pkgs.kubernetes-helm
      # kustomize - Customization of kubernetes yaml configurations
      # pkgs.kustomize
      # k9s - Kubernetes TUI
      # pkgs.k9s
      # Simple terminal UI for git commands
      # pkgs.lazygit
      # The Lua programming language
      # pkgs.lua
      # luarocks - Lua package manager
      # pkgs.lua52Packages.luarocks
      # Midnight Commander TUI
      # pkgs.mc
      # Quick'n'dirty tool to make APFS aliases
      # Used for making GUI apps installed with nix available in Spotlight search
      # pkgs.mkalias
      # Build automation tool (used primarily for Java projects)
      # pkgs.maven
      # Mac App Store command line interface
      # pkgs.mas
      # Tool that makes it easy to run Kubernetes locally
      # pkgs.minikube
      # NeoVim - Text editor
      # pkgs.neovim
      # Obsidian PKM tool
      # pkgs.obsidian
      # Prompt theme engine for any shell
      # pkgs.oh-my-posh
      # PlantUML diagrams-as-code tool
      # pkgs.plantuml
      # podman - container runtime
      # pkgs.podman
      # postresql - Postresql database
      # pkgs.postgresql
      # prettier as a daemon, for improved formatting speed
      # pkgs.prettierd
      # pwgen - a password generator for the commanline
      # pkgs.pwgen
      # Python 3 programming language
      # pkgs.python313
      # Raycast shortcut tool (replacement for Apple Spotlight)
      # pkgs.raycast
      # Utility that combines the usability of The Silver Searcher with the raw speed of grep
      # Needed by NeoVim plugins
      # pkgs.ripgrep
      # Fast incremental file transfer utility
      # pkgs.rsync
      # rustup - Rust toolchain installer
      # pkgs.rustup
      # rust-analyzer - Language Server for Rust
      # pkgs.rust-analyzer
      # Easy and Repeatable Kubernetes Development
      # pkgs.skaffold
      # smartmontools - Tools for monitoring the health of hard drives
      # pkgs.smartmontools
      # sops - tool for managing secrets
      # pkgs.sops
      # statix - Nix programming language linter
      # pkgs.statix
      # stow symlink farm manger
      # Used for my dotfiles
      # pkgs.stow
      # talosctl - Talos Linux CLI tool
      # pkgs.talosctl
      # structurizr-cli - The structurizr CLI for publishing C4 architecture diagrams
      # pkgs.structurizr-cli
      # subversion - the version control system from hell
      # pkgs.subversion
      # talhelper - tool to make a Talos Linux config gitops friendly
      # pkgs.talhelper
      # talosctl - Talos Linux CLI tool
      # pkgs.talosctl
      # Task - a modern task runner
      # pkgs.go-task
      # tenv - OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go
      # pkgs.tenv
      # tree-sitter - tree-sitter CLI (required for neovim treesitter plugin)
      # pkgs.tree-sitter
      # tmux - terminal multiplexer
      # pkgs.tmux
      # tmuxifier - session, window & pane management tool for tmux
      # pkgs.tmuxifier
      # Command to produce a depth indented directory listing
      # pkgs.tree
      # uv - python package installer and resolver
      # pkgs.uv
      # Visual Studio Code
      # pkgs.vscode
      # Tool for retrieving files using HTTP, HTTPS, and FTP
      # pkgs.wget
      # yq - command line yaml processor
      # pkgs.yq
      # Fast cd command that learns your habits
      # pkgs.zoxide
      # Azul Zulu OpenJDK
      # pkgs.zulu25
    ];
  };
}
