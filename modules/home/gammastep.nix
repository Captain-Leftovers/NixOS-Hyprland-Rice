{ pkgs, ... }:

{

 # home.packages = with pkgs; [ gammastep ];

programs.gammastep = {
  enable = true;
  latitude = "33.8688";
  longitude = "151.2093";
  temperature = {
    day = 5500;
    night = 3700;
  };
}
;
}
