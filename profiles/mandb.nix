{ self, config, lib, pkgs, ... }:

{
  # TODO: make into module
  environment.systemPackages = [ pkgs.man-db ];
  systemd.services.mandb = {
    wantedBy = [ "multi-user.target" ];
    after = [ "default.target" ];
    description = "service to update mandb";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "/run/current-system/sw/bin/mkdir -p /var/cache/mandb/nixos" "/run/current-system/sw/bin/mandb" ];
      RemainAfterExit = true;
    };
  };
}
