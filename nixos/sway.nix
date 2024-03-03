{ pkgs, ... }:
{
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_BIN_HOME    = "$HOME/.local/bin";
    # PATH = [ 
    #   "/run/current-system/sw/bin"
    #   "${XDG_BIN_HOME}"
    # ];
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland-egl";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XCURSOR_THEME = "Adwaita";
    GTK_THEME = "Adwaita";
  };

  security.polkit.enable = true;
  networking.networkmanager.enable = true;

  sound.enable = false; # only for ALSA wiki/PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # wireplumber.enable = true;
  };

  services.dbus.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # Enable the gnome-keyrig secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
