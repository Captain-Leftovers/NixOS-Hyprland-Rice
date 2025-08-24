{ config, pkgs, inputs, lib, ... }:

let
  system = pkgs.system;
in
{
  programs.opencode = {
    enable = true;

    package = inputs.opencode.packages.${system}.opencode;

    settings = {
      theme = "dark";
    };
  };
}
