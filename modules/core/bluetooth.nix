{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  # Optional: allow user access
 # users.users.${config.networking.hostName}.extraGroups = [ "bluetooth" ];
}
