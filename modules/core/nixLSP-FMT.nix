{ pkgs, inputs, ... }:

{
  # add nixd to the system packages
  environment.systemPackages = with pkgs; [
    # Installs the nixd package for Nix daemon support
    nixfmt-rfc-style
    nixd
  ];

   nix.nixpath = ["nixpkgs=${inputs.nixpkgs}"];
}