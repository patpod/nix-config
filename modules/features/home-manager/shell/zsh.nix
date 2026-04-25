{ self, input, ... }:
{
  flake.homeModules.zsh =
    { config, pkgs, ... }:
    {
      programs.zsh = {
        enable = true;

        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "sudo"
            "terraform"
            "command-not-found"
            "kubectl"
            "kubectx"
            "common-aliases"
          ];
        };

        plugins = [
          {
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
            file = "fzf-tab.plugin.zsh";
          }
          {
            name = "zsh-completions";
            src = "${pkgs.zsh-completions}/share/zsh-completions";
            file = "zsh-completions.plugin.zsh";
          }
        ];

        history = {
          size = 5000;
          save = 5000;
          path = "${config.xdg.dataHome}/zsh/history";
          ignoreDups = true;
          ignoreSpace = true;
          ignoreAllDups = true;
          share = true;
        };

        initContent = ''
          # History setopts not covered natively
          setopt appendhistory
          setopt hist_save_no_dups
          setopt hist_find_no_dups

          # Completion styling
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        '';

        shellAliases = {
          # ==========================================
          # Modern Command Replacements
          # ==========================================

          # cat -> bat
          cat = "bat";
          # If you ever actually need plain unformatted text, use 'bat -p' (plain)
          catp = "bat -p";

          # top / htop -> btop
          top = "btop";
          htop = "btop";

          # ps -> procs
          ps = "procs";

          # grep -> ripgrep (rg)
          # rg is already short, but muscle memory is strong!
          grep = "rg";

          # find -> fd
          find = "fd";

          # ==========================================
          # eza (ls replacement) overrides
          # ==========================================
          # Note: If you set `programs.eza.enableZshIntegration = true;`,
          # HM already maps ls, ll, la, etc.
          # BUT, defining them here lets you add extra flags like putting directories first!

          ls = "eza --icons --group-directories-first";
          ll = "eza -l -g --icons --group-directories-first"; # Long format
          la = "eza -la -g --icons --group-directories-first"; # Long format + hidden files
          lt = "eza --tree --level=2 --icons --group-directories-first"; # Tree view
        };
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

    };
}
