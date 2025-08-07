{ pkgs, ... }:

{

  services.gammastep = {
    enable = true;
    provider = "manual";  # 👈 tells it to use your own coordinates
    latitude = 33.8688;   # Sydney
    longitude = 151.2093;
    temperature = {
      day = 5500;
      night = 3700;
    };
    tray = true; # optional: tray icon
  };
  
}
