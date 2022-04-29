{ self, hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) drpyser; };
  age.secrets.drpyser-password.file = "${self}/secrets/drpyser-password.age";

  users.users.drpyser =
    let
      passwordFile = "/run/agenix/drpyser-password";
    in
    {
      # password = "nixos";
      passwordFile = passwordFile;
      description = "my personal user";
      isNormalUser = true;
      # createHome = true;
      group = "users";
      extraGroups = [ "adbusers" "wheel" "networkmanager" "audio" "video" ];
    };
}
