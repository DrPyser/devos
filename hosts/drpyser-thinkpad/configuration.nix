# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # graphical interface config
      # ./graphical.nix
      # misc services
      # ./services.nix
      # ./games.nix
      # ./python.nix
      # ./docker.nix
      # ./fs.nix
      # ./ipfs.nix
      # ./keybase.nix
      #      ./wireguard.nix
      #      ./hyperdrive.nix
    ];

  # TODO: move to profile(core? nix?)
  # nix package manager config
  nix = {
    # package = pkgs.nix_2_7; # or versioned attributes like nix_2_4
    autoOptimiseStore = true;
    gc.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    trustedUsers = [
      "root"
      "@wheel"
    ];
    # register system flakes here?
    registry = { };

  };
  nixpkgs.config.allowUnfree = true;

  ## boot settings
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # configuration for disk encryption
  boot.initrd.luks.devices.root = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
  };
  boot.loader.grub.device = "/dev/nvme0n1p1";
  # bootloader prettyness
  boot.plymouth.enable = true;
  # sysctl parameters
  boot.kernel.sysctl."net.core.rmem_max" = 419430;
  boot.kernel.sysctl."net.core.wmem_max" = 1048576;

  ## custom hardware settings
  # Bluetooth support can be extracted to profile(laptop?)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;

  # fingerprint reader support
  # machine-specific
  services.fprintd.enable = true;

  services.gvfs.enable = true; # enables gvfs

  services.gnome.gnome-keyring.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp61s0.useDHCP = true;
  # put in core profile?
  networking.networkmanager.enable = true;

  networking.hostName = "drpyser-thinkpad"; # Define your hostname.
  # extract to separate profile?
  networking.extraHosts = ''
    155.138.159.149 viachicago.vultr
    155.138.145.227 endlessendeavor.vultr
    # for ssh tunneling
    # 127.0.0.2 viachicago.local ipfs.local
    # 127.0.0.1 viachicago.local *.localhost
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # systemd DNS resolver
  # Currently breaks system
  #  services.resolved.enable = true;
  #  services.resolved.fallbackDns = [ "192.168.8.1" "8.8.8.8" ];

  # extract to networking tools profile
  programs.mtr.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console.useXkbConfig = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # TODO: move packages to separate profiles
  environment.systemPackages = with pkgs; [
    # basic utilities
    dash
    tree
    file
    gnumake
    git
    htop
    which

    # web browsing
    firefox
    #(brave.override { })

    # terminal
    # TODO: package it up
    alacritty
    tmux

    # default editor toolkit
    # TODO: package it up along with any plugins, configuration and related tooling
    kakoune
    kak-lsp

    # basic graphical interface tools
    brightnessctl
    libnotify
    dunst
    xsel
    xdotool
    dmenu
    networkmanagerapplet

    # security tooling
    lxqt.lxqt-policykit
    pinentry
    gnupg
    pass

    stow # symlink manager. Can be replaced by nix

    # backup tooling
    borgbackup

    man-pages
    man-pages-posix
    groff # manpage typesetting toolkit
    tealdeer # tldr alternative man pages

    # networking tools
    wget
    aria2
    ncat
    telnet #
    tcpdump
    mosh # better ssh

    cachix # binary cache for nix
    home-manager # nix home environment manager

    bat
    ripgrep # text pattern finder
    lsd # prettier ls
    fd
    jq

    fzf # fuzzy finder/selector
    fish
    fishPlugins.fzf-fish
    direnv

    lorri
    any-nix-shell
    nixos-option
  ];

  # fonts and appearance configuration
  # TODO: Separate profile for appearance settings?
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
  fonts.fontDir.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [
    "FiraCode Nerd Font Mono"
  ];

  # better nix-shell
  # extract to nix tools profile
  services.lorri.enable = true;


  # Open ports in the firewall.
  # wireguard port
  # TODO: VPN peer profile
  # networking.firewall.allowedUDPPorts = [ 11408 ];

  # Enable sound.
  # TODO: move to laptop profile?
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # see shell profiles for shell config
  users.defaultUserShell = pkgs.fish;

  # User profiles configured in users/ directory

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.drpyser = {
  #   # createhome = true;
  #   isnormaluser = true;
  #   description = "my personal user";
  #   group = "users";
  #   extraGroups = [ "adbusers" "wheel" "networkmanager" "audio" "video" ];
  #   # shell = pkgs.fish;
  # };
  security.pam.services.drpyser.enableGnomeKeyring = true;

  # setup documentation resources
  # TODO: install tldr client, other improvements for/over man
  # documentation.dev.enable = true;
  # documentation.man.enable = true;
  # documentation.man.generateCaches = true;
  # documentation.nixos.enable = true;
  # documentation.nixos.includeAllModules = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?

}
