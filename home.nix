{
  config,
  pkgs,
  lazyvim,
  ...
}:

{
  home.username = "ken";
  home.homeDirectory = "/home/ken";
  home.stateVersion = "25.11";

  ##############
  ## PACKAGES
  home.packages = with pkgs; [
    gcc
    nodejs_24
    tree-sitter
    statix
    markdownlint-cli2
    neovim
    devenv
    ripgrep
    nil
    nixpkgs-fmt
    wofi
    nitch
    rofi
    pcmanfm
    mise
    xfce.thunar
    alacritty
    nwg-look
    hyprshot
    satty
    stow
    caligula

    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        (nix-search-tv.overrideAttrs {
          env.GOEXPERIMENT = "jsonv2";
        })
      ];
      text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
    })
  ];

  ##############
  ## PROGRAMS
  programs.sherlock.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.zellij.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "alanpeabody";
      plugins = [
        "git"
        "sudo"
      ];
    };
    history = {
      append = true;
      share = false;
    };
    initContent = ''
      DISABLE_UNTRACKED_FILES_DIRTY="true"
      eval "$(${pkgs.mise}/bin/mise activate zsh)"
    '';
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    daemon.enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      "style" = "full";
      "auto_sync" = "true";
      "sync_frequency" = "5m";
      "sync_address" = "https://atuin.r7n.dev";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };
      settings = {
        alias = {
          s = "status";
          lg = "log --oneline --graph --decorate";
        };
      };
      core.editor = "vim";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        name = "Ken Robertson";
        email = "ken@invalidlogic.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS1AGHAlRPNp394oZrYtpH6hR2sJ12BwzpqoYmBlQ9I";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };

  ##############
  ## SERVICES
  services.lxqt-policykit-agent.enable = true;
  services.gnome-keyring.enable = true;

  ##############
  ## APPEARANCE
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-hdpi";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "alacritty.desktop"
      ];
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "com.vivaldi.Vivaldi.desktop";
      "x-scheme-handler/http" = "com.vivaldi.Vivaldi.desktop";
      "x-scheme-handler/https" = "com.vivaldi.Vivaldi.desktop";
      "x-scheme-handler/about" = "com.vivaldi.Vivaldi.desktop";
      "x-scheme-handler/unknow" = "com.vivaldi.Vivaldi.desktop";
    };
  };
}
