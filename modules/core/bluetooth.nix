{ config, pkgs, ... }:

{
  # Enables Bluetooth support system-wide (loads the BlueZ stack and bluetoothd)
  hardware.bluetooth.enable = true;

  # Optional: enables the blueman service (not needed unless you want it to auto-run)
  # services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    # Installs the blueman GUI app — used to manage Bluetooth devices with a tray icon
    # Remove this if you don’t want any GUI (or replace with blueberry or just use CLI tools)
    blueman
  ];

  # Prevents the blueman tray app from launching on login, even if installed
  # This is a custom override of the autostart entry, telling your session "don’t run this"
  environment.etc."xdg/autostart/blueman.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  # Optional: adds your user to the 'bluetooth' group so you can control Bluetooth (e.g., via bluetoothctl)
  # You should uncomment this if you want to power on/off devices or pair from your user account
  # users.users.beeondweb.extraGroups = [ "bluetooth" ];
}
