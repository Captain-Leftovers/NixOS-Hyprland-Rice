{ pkgs, inputs, ... }:

{
  # add nixd to the system packages
  environment.systemPackages = with pkgs; [
    # Installs the nixd package for Nix daemon support
    nixd
  ];

   nix.nixpath = ["nixpkgs=${inputs.nixpkgs}"];
}