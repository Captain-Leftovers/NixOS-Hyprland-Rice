{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;

    addKeysToAgent = "1h";  # Adds keys to the agent for 1 hour

    matchBlocks = {
      github = {
        host = "github.com";
        hostname = "ssh.github.com";
        user = "git";
        port = 22;
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        extraOptions = {
          IPQoS = "throughput";
        };
      };
    };
  };

  services.ssh-agent.enable = true;


}
