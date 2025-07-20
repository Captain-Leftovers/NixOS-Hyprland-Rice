{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    blueman
  ];

  users.users.beeondweb.extraGroups = [ "bluetooth" ];
}
