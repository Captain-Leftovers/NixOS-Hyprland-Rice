{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    # Same as before: upstream repo, not a flake.
    opencode-src = {
      url = "github:sst/opencode";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, opencode-src, ... }:
    # same structure: per-system outputs
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # ─────────────────────────────────────────────────────────────────────
        # NEW: try to read a version from either package.json or opencode.json.
        # If neither has "version", fall back to "latest".
        # ─────────────────────────────────────────────────────────────────────
        pkgJsonPath = "${opencode-src}/package.json";
        hasPkgJson  = builtins.pathExists pkgJsonPath;
        pkgJson     = if hasPkgJson
                      then builtins.fromJSON (builtins.readFile pkgJsonPath)
                      else {};
        openJsonPath = "${opencode-src}/opencode.json";
        hasOpenJson  = builtins.pathExists openJsonPath;
        openJson     = if hasOpenJson
                       then builtins.fromJSON (builtins.readFile openJsonPath)
                       else {};

        upstreamVersion =
          if pkgJson ? version then pkgJson.version
          else if openJson ? version then openJson.version
          else "latest";  # CHANGED: no hard assumption; safe fallback

        # ─────────────────────────────────────────────────────────────────────
        # NEW: map the current system to the right release asset name
        # ─────────────────────────────────────────────────────────────────────
        assetFor = {
          "x86_64-linux"  = "opencode-linux-x64.zip";
          "aarch64-linux" = "opencode-linux-arm64.zip";
          "x86_64-darwin" = "opencode-macos-x64.zip";
          "aarch64-darwin"= "opencode-macos-arm64.zip";
        };

        asset = assetFor.${system}
          or (throw "OpenCode: unsupported system ${system}");

        # ─────────────────────────────────────────────────────────────────────
        # CHANGED: build the download URL. If we found a version, use /vX.Y.Z/;
        # otherwise use /releases/latest/download/.
        # ─────────────────────────────────────────────────────────────────────
        url =
          if upstreamVersion == "latest"
          then "https://github.com/sst/opencode/releases/latest/download/${asset}"
          else "https://github.com/sst/opencode/releases/download/v${upstreamVersion}/${asset}";

        # ─────────────────────────────────────────────────────────────────────
        # CHANGED: per-system sha256 placeholders. First build will tell you the
        # correct one; paste it back here and rebuild.
        # ─────────────────────────────────────────────────────────────────────
        sha256For = {
          "x86_64-linux"  = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          "aarch64-linux" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          "x86_64-darwin" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          "aarch64-darwin"= "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };

        sha256 = sha256For.${system}
          or (throw "OpenCode: add sha256 for ${system}");
      in
      {
        packages = rec {
          # ───────────────────────────────────────────────────────────────────
          # CHANGED: install the prebuilt binary from the release zip
          # instead of trying to build from source (repo mixes Bun + Go).
          # Upstream officially documents the prebuilt paths. :contentReference[oaicite:1]{index=1}
          # ───────────────────────────────────────────────────────────────────
          opencode = pkgs.stdenvNoCC.mkDerivation {
            pname   = "opencode";
            version = upstreamVersion;

            src = pkgs.fetchzip {
              inherit url sha256;
              stripRoot = false;  # binary is at top-level inside the zip
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

          default = opencode; # same convenience alias
        };
      }
    )
    # ─────────────────────────────────────────────────────────────────────────
    # NEW: expose the Home-Manager module at TOP LEVEL, not per-system,
    # so you can import it as inputs.opencode.homeManagerModules.default.
    # ─────────────────────────────────────────────────────────────────────────
    // {
      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg    = config.programs.opencode;
          system = pkgs.stdenv.hostPlatform.system;
          opkg   = self.packages.${system}.opencode;  # correct system package
        in
        {
          options.programs.opencode = {
            enable = lib.mkEnableOption "Install and configure OpenCode";

            package = lib.mkOption {
              type        = lib.types.package;
              default     = opkg;
              description = "Which opencode package to install.";
            };

            settings = lib.mkOption {
              type        = lib.types.attrs;
              default     = { };
              description = "OpenCode settings written to ~/.config/opencode/config.json";
            };
          };

          config = lib.mkIf cfg.enable {
            # Optional runtime helpers (AUR’s opencode-bin recommends fzf + ripgrep)
            home.packages = [ cfg.package pkgs.fzf pkgs.ripgrep ];

            xdg.configFile."opencode/config.json".text =
              builtins.toJSON cfg.settings;
          };
        };
    };
}
