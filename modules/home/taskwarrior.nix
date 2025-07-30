{ config, pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true; # Enable Taskwarrior
    package = pkgs.taskwarrior3; # Use version 3.x, not the old 2.x

    config = {
      data.location = "${config.xdg.dataHome}/task";
      color = "on";
      default.project = "inbox";
      report.next.columns = "id,start,entry,project,due,description,urgency";
    };

    extraConfig = ''
      urgency.user.tag.work.coefficient=10.0
    '';
  };


  #if you need sync see docs and what ese you will need
  # services.taskwarrior-sync = {
  #   enable = true; # Enables periodic sync via systemd timer
  #   frequency = "hourly"; # Could be "daily", "weekly", etc.
  #   package = pkgs.taskwarrior3;
  # };
}
