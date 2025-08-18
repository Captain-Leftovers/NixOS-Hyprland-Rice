{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    direnv
    nix-direnv
  ];

  #set to default values
  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
}
