{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia-disable
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ./packages.nix
    ./ab.nix
    ./sway.nix
  ];

  hardware.enableRedistributableFirmware = true;
  

  nixpkgs = {
    overlays = [
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
	      name = "nix/path/${name}";
	      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ 
    "amdgpu" 
    "snd_pci_acp6x" 
    "snd_soc_acp6x_mach"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPatches = [ {
    name = "enable-amd-mic";
    patch = null;
    extraConfig = ''
            SND_SOC m
            SND_SOC_AMD_ACP6x m
            SND_SOC_AMD_YC_MACH m
    '';
  } ];
  boot.kernelParams = [ 
    "snd_hda_intel.dmic_detect=0" 
    "snd-intel-dspcfg.dsp_driver=3" 
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.pcscd.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.gnupg.agent = {
     enable = true;
     # pinentryFlavor = "curses";
     enableSSHSupport = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
