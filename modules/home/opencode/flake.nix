{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # same helper you had
    flake-utils.url = "github:numtide/flake-utils";

    # upstream OpenCode source repo (not a flake) — you update this via: nix flake update opencode
    opencode-src = {
      url = "github:sst/opencode";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, opencode-src, ... }:
    # We still use flake-utils to generate per-system outputs
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # NEW: read OpenCode version from upstream package.json (pinned by flake.lock)
        upstreamVersion =
          (builtins.fromJSON (builtins.readFile "${opencode-src}/package.json")).version;

        # NEW: map each system to the correct release asset filename
        assetFor = {
          "x86_64-linux" = "opencode-linux-x64.zip";
          "aarch64-linux" = "opencode-linux-arm64.zip";
          "x86_64-darwin" = "opencode-macos-x64.zip";
          "aarch64-darwin" = "opencode-macos-arm64.zip";
        };

        # NEW: pick asset for current system (errors if unsupported)
        asset = assetFor.${system}
          or (throw "OpenCode: unsupported system ${system}");

        # NEW: compose the release URL based on upstreamVersion + asset
        url = "https://github.com/sst/opencode/releases/download/v${upstreamVersion}/${asset}";

        # NEW: per-system fixed-output hash (put the real one after first build)
        sha256For = {
          "x86_64-linux" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          "aarch64-linux" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          "x86_64-darwin" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          "aarch64-darwin" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };

        sha256 = sha256For.${system}
          or (throw "OpenCode: add sha256 for ${system}");
      in
      {
        packages = rec {
          # CHANGED: instead of pkgs.buildGoModule { ... } (which failed),
          # we fetch the upstream prebuilt release archive and install the binary.
          opencode = pkgs.stdenvNoCC.mkDerivation {
            pname   = "opencode";
            version = upstreamVersion;

            src = pkgs.fetchzip {
              inherit url sha256;
              stripRoot = false; # zip contains 'opencode' at top-level
            };

            dontConfigure = true;
            dontBuild     = true;

            installPhase = ''
              install -Dm755 opencode "$out/bin/opencode"
            '';

            meta = {
              description = "OpenCode — AI coding agent, built for the terminal";
              homepage    = "https://github.com/sst/opencode";
              license     = pkgs.lib.licenses.mit;
              platforms   = pkgs.lib.platforms.all;
            };
          };

          # keep the convenience alias
          default = opencode;
        };
      }
    )
    # NEW: expose Home-Manager module at the TOP LEVEL (not per-system),
    # so you can import it as inputs.opencode.homeManagerModules.default
    // {
      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg    = config.programs.opencode;
          system = pkgs.stdenv.hostPlatform.system;
          # Use the package we just defined for THIS system
          opkg   = self.packages.${system}.opencode;
        in
        {
          options.programs.opencode = {
            enable = lib.mkEnableOption "Install and configure OpenCode";

            package = lib.mkOption {
              type        = lib.types.package;
              default     = opkg;        # default to our packaged binary
              description = "Which opencode package to install.";
            };

            # Anything you put here is written to ~/.config/opencode/config.json
            settings = lib.mkOption {
              type        = lib.types.attrs;
              default     = { };
              description = "OpenCode settings written to XDG config.";
            };
          };

          config = lib.mkIf cfg.enable {
            # Install binary and helpful runtime deps (fzf/rg are commonly used by opencode)
            home.packages = [ cfg.package pkgs.fzf pkgs.ripgrep ];

            # Write ~/.config/opencode/config.json
            xdg.configFile."opencode/config.json".text =
              builtins.toJSON cfg.settings;
          };
        };
    };
}
