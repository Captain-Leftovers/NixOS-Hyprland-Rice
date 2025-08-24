{  
  config,
  pkgs,
  inputs,
  ... }:

{
  imports = [
    inputs.opencode.homeManagerModules.default
  ];

  programs.opencode.enable = true;

  # optional configs you want written to ~/.config/opencode/config.json
  programs.opencode.settings = {
    theme = "dark";
    telemetry = false;
  };
}
1
