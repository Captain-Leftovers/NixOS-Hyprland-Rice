{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    # Allow all users to write to the keyboard backlight device
    SUBSYSTEM=="leds", KERNEL=="tpacpi::kbd_backlight", MODE="0666", TAG+="uaccess"
  '';
}
