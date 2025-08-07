{ pkgs, ... }:

{
  # in your NixOS config (NOT home-manager)
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 33.8688;
    longitude = 151.2093;
    temperature = {
      day = 5500;
      night = 3700;
    };
    tray = true;
  };
  
}
