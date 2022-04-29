### Setup graphical configuration
# { config, pkgs, ... }:
{ self, config, lib, pkgs, ... }:
{

  # wm-independent configuration/overrides

  # Xorg configuration
  services.xserver.enable = true;
  services.xserver.layout = "ca";
  services.xserver.xkbOptions = "caps:super";
  # https://man.archlinux.org/man/DPMSSetTimeouts.3
  services.xserver.serverFlagsSection = ''
    Option "StandbyTime" "10"
    Option "SuspendTime" "60"
    Option "OffTime" "360"
    Option "BlankTime" "0"
  '';

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";

  environment.systemPackages = [
    # graphical prompt/selector
    pkgs.dmenu

    # clipboard manager
    pkgs.xsel
    # misc xorg tool
    pkgs.xdotool

    # notification daemon
    pkgs.libnotify
    pkgs.dunst

    pkgs.i3

    # status bar
    pkgs.i3blocks
  ];

}
