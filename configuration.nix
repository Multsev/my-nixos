{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  system.stateVersion = "21.11";
  time.timeZone = "Europe/Moscow";
  virtualisation.docker.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.autoOptimiseStore = true;

  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/sda";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
    # useDHCP = true;
    # interfaces.enp0s3.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 3389 ];
    firewall.allowedUDPPorts = [ ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      xkbOptions = "caps:escape";
      layout = "us";
      libinput.enable = true;
    };
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };
    printing = {
      enable = true;
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
    };
  };

  users = {
    users.root = {
      hashedPassword = ""; # mkpasswd -m sha-512
    };
    users.max = {
      isNormalUser = true;
      group = "wheel";
      extraGroups = [ "users" "docker" ];
      createHome = true;
      home = "/home/max";
      hashedPassword = ""; # mkpasswd -m sha-512
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    appimage-run
    docker-compose
    go
  ];

  home-manager.users.max = {
    home.packages = with pkgs; [
      latte-dock
      libsForQt5.ark
      libsForQt5.kdeconnect-kde
      libsForQt5.krdc
      libsForQt5.kmail
      libsForQt5.elisa
      libsForQt5.krfb
      libsForQt5.kget
      libsForQt5.konqueror
      libsForQt5.kontact
      ktorrent
      kdevelop-unwrapped
      keepass
      firefox-unwrapped
      vscodium
      tdesktop
      whatsapp-for-linux
      anydesk
      winbox
      libreoffice-fresh-unwrapped
      rclone
      rclone-browser
      drawio
    ];
    programs = {
      git = {
        enable = true;
        package = pkgs.git;
        userName  = "multsev";
        userEmail = "multsev.m.a@gmail.com";
      };
      neovim = {
        enable = true;
        package = pkgs.neovim-unwrapped;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
    };
  };

    # xdg.configFile."i3blocks/config".source = ./i3blocks.conf;
    # home.file.".gdbinit".text = ''
    #     set auto-load safe-path /nix/store
    # '';

}
