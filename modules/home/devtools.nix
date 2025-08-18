{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;        # optional, overrides default direnv
    loadInNixShell = true;        # auto-load in nix-shell
    silent = false;
    direnvrcExtra = "";           # optional extra config
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;  # install nix-direnv properly
    };
  };
}
