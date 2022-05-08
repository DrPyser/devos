{ suites, pkgs, ... }:
{
  imports = [
  ] ++ suites.server;

  bud.enable = true;
  bud.localFlakeClone = "/home/nixos/devos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };

  # non-specific environment setup in profiles

}

