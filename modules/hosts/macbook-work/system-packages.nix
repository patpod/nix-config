{ self, inputs, ... }:
{

  flake.darwinModules.sysPackages =
    { pkgs, ... }:
    {

      environment.systemPackages = [
        # GNU coreutils - the ones that come with MacOS are outdated
        pkgs.coreutils
        # GNU implementation of the grep command (installed on mac for compatibility in scipts)
        pkgs.gnugrep
        # Quick'n'dirty tool to make APFS aliases
        # Used for making GUI apps installed with nix available in Spotlight search
        pkgs.mkalias

        # Ansible - Configuration management tool
        # pkgs.ansible
        # Azure CLI - Next generation multi-platform command line experience for Azure
        # pkgs.azure-cli
        # bruno - Open Source IDE for exploring and testing APIs
        # pkgs.bruno
        # bun - Javascript/Typescript runtime
        # pkgs.bun
        # Rust build tool
        # pkgs.cargo
        # difftastic - sytax aware diff tool
        # pkgs.difftastic
        # d2 - diagram scripting language
        # pkgs.d2
        # Feh lightweight image viewer
        # Used for displaying PlantUML diagrams
        # pkgs.feh
        # GNU find utils
        # pkgs.findutils
        # Fast Node Manager - Fast and simple Node.js version manager
        # pkgs.fnm
        # Garage object store - used for the included cli
        # pkgs.garage_2
        # GNU Privacy Guard
        # e.g., used to sign git commits
        # pkgs.gnupg
        # Google Cloud SDK - GCP command line utilities
        # pkgs.google-cloud-sdk
        # Go programming language
        # pkgs.go
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
        # Midnight Commander TUI
        # pkgs.mc
        # Build automation tool (used primarily for Java projects)
        # pkgs.maven
        # Tool that makes it easy to run Kubernetes locally
        # pkgs.minikube
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
        # tmuxifier - session, window & pane management tool for tmux
        # pkgs.tmuxifier
        # uv - python package installer and resolver
        # pkgs.uv
        # Visual Studio Code
        # pkgs.vscode
        # Azul Zulu OpenJDK
        # pkgs.zulu25
      ];
    };
}
