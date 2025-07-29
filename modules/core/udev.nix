{ config, pkgs, ... }:

{
  environment.etc."tmpfiles.d/kbd-backlight.conf".text = ''
    f /sys/class/leds/tpacpi::kbd_backlight/brightness 0666 root root -
  '';
}
