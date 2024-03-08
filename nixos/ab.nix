{pkgs, ...}: {
  programs.fish.enable = true;
  users.users = {
    ab = {
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "/home/ab/.ssh/id_ed25519.pub"
      ];
      extraGroups = ["wheel" "networkmanager" "docker" "video"];
    };
  };

  nix.settings.trusted-users = [
    "root"
    "ab"
    "@wheel"
  ];

  networking.hostName = "abdev";
  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };
}
