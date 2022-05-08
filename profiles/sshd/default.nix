{ self, config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  # Sets nrdxp.cachix.org binary cache which just speeds up some builds
  imports = [ ../cachix ];

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}
