{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  programs.uwsm = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    cascadia-code
    font-awesome
    nerd-fonts.inconsolata
    nerd-fonts.mononoki
    nerd-fonts.jetbrains-mono
  ];

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    greetd
    pavucontrol
    mako
    wiremix
    pamixer
    bluetui
    brightnessctl
    lxqt.lxqt-policykit
    wtype
    fuzzel
    gammastep
    wayland-utils
    tokyonight-gtk-theme
    adwaita-icon-theme
    papirus-icon-theme
  ];

  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
        user = "ken";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -c ${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
        user = "greeter";
      };
    };
  };

}
