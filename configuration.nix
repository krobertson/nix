{
  config,
  lib,
  pkgs,
  nix-flatpak,
  ...
}:

{
  ##############
  ## IMPORTS
  imports = [
    ./hardware-configuration.nix
    ./wayland.nix
  ];

  ##############
  ## BASICS
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "America/Los_Angeles";
  networking.hostName = "framework";

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.powersave = false;
  };

  ##############
  ## USERS
  programs.zsh.enable = true;
  users.users.ken = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "docker"
    ];
    packages = with pkgs; [
      tree
    ];
  };
  nix.settings.trusted-users = [
    "root"
    "ken"
  ];

  ##############
  ## PACKAGES
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    zx
    nix-index
    nvd
    vim
    wget
    lazydocker
    jocalsend
    localsend
    bottles
    flatpak-xdg-utils
    _1password-cli
    _1password-gui
  ];

  ##############
  ## SERVICES
  services.openssh.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features = {
        # ensure buildkit on
        buildkit = true;
      };
    };
  };
  services.flatpak = {
    enable = true;
    update.auto.enable = false;
    uninstallUnmanaged = false;
    packages = [
      "com.github.tchx84.Flatseal"
      "com.vivaldi.Vivaldi"
      "com.valvesoftware.Steam"
      "md.obsidian.Obsidian"
      "io.github.martchus.syncthingtray"
      "org.chromium.Chromium"
    ];
    overrides = {
      "com.vivaldi.Vivaldi".Context = {
        filesystems = [
          "home/Downloads"
        ];
      };
    };
  };

  ##############
  ## HARDWARE
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # needed for 32-bit DX9 via Wine/DXVK
  };

  ##############
  ## SECURITY
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  programs._1password-gui.enable = true;
  programs._1password.enable = true;
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
        zen
        flatpak-session-helper
      '';
      mode = "0755";
    };
  };

  ##############
  ## NIX/UPDATES
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
