{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ expressvpn ];

  systemd.services.expressvpnd = {
    description = "ExpressVPN Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.expressvpn}/bin/expressvpnd";
      Restart = "always";
    };
  };

  systemd.services.expressvpn-autoconnect = {
    description = "Auto-connect ExpressVPN";
    after = [
      "network-online.target"
      "expressvpnd.service"
    ];
    requires = [ "expressvpnd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.expressvpn}/bin/expressvpn connect smart";
      Restart = "on-failure";
    };
  };

  systemd.services.expressvpn-network-lock = {
    description = "Enable Network Lock for ExpressVPN";
    after = [ "expressvpnd.service" ];
    requires = [ "expressvpnd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.expressvpn}/bin/expressvpn preferences set network_lock on";
      Restart = "on-failure";
    };
  };
}
