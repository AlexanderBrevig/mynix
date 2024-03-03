{ pkgs, ... }:
let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in
{
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.light.enable = true;
  environment.systemPackages = with pkgs; [
    git
    wezterm
    alacritty
    fish
    starship
    zoxide
    ripgrep
    unzip
    stow
    eza
    jq
    yq
    tealdeer
    fzf
    bottom
    htop
    inxi
    neofetch
    lolcat
    pinentry
    gh
    
    dbus
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils
    glib
    dracula-theme
    gnome3.adwaita-icon-theme
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
    mako
    wdisplays

    wofi
    swappy
    waybar
    wl-mirror
    pulseaudio
    pavucontrol
    killall
    pciutils


    bitwarden
    bitwarden-cli

    inkscape
    gimp
    google-chrome
    slack

    gnumake
    cmake
    libgcc
    clang
    python3
    rustup
    go
    openssl
    openssl.dev
    pkg-config

    asdf-vm
    docker
    kubernetes-helm
    kubectx
    postgresql
    k9s

    nil
    nodePackages.prettier
    shellcheck
    yaml-language-server
    nodePackages.bash-language-server
    python311Packages.python-lsp-server

    neovim
  ];
}
