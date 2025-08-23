{
  description = "OpenCode (sst/opencode) - nested flake: package stub + Home Manager module";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
  in
  {
    # TEMP: a tiny stub package so this flake evaluates now.
    packages = forAllSystems (pkgs: rec {
      opencode = pkgs.stdenvNoCC.mkDerivation {
        pname = "opencode-stub";
        version = "0.0.0";
        src = pkgs.emptyDirectory;
        installPhase = ''
          mkdir -p $out/bin
          cat > $out/bin/opencode <<'SH'
          #!/usr/bin/env bash
          echo "OpenCode is not packaged yet. We'll wire the real binary in Step 2."
          SH
          chmod +x $out/bin/opencode
        '';
      };
      default = opencode;
    });

    # Home Manager module that exposes programs.opencode.enable
    homeManagerModules.default = { lib, config, pkgs, ... }:
      let
        cfg = config.programs.opencode;
      in
      {
        options.programs.opencode.enable =
          lib.mkEnableOption "Install OpenCode and (later) manage its config";

        config = lib.mkIf cfg.enable {
          # For now, just install the stub. In Step 2 we swap to the real package.
          home.packages = [ self.packages.${pkgs.system}.opencode ];

          # Placeholder for future dotfiles (we'll fill in later)
          # xdg.configFile."opencode/config.json".text = ''{ }'';
        };
      };
  };
}
