### Setup graphical configuration
# { config, pkgs, ... }:
{ self, config, lib, pkgs, ... }:
{

  environment.pathsToLink = [ "/libexec" ];

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
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock
      xdotool
      dunst
      libnotify
      i3blocks
      xsel
      light
    ];
  };
  services.xserver.displayManager.defaultSession = "none+i3";
}
