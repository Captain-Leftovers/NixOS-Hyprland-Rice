{
  inputs = {
    # Pull the same nixpkgs your root flake uses (no duplication).
    nixpkgs.follows = "nixpkgs";

    # Utility to generate outputs for each system (x86_64-linux, aarch64-darwin, …).
    flake-utils.url = "github:numtide/flake-utils";

    # Upstream OpenCode source. Not a flake, just the repo contents.
    # You will update THIS input when you want a newer OpenCode.
    opencode-src = {
      url = "github:sst/opencode";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, opencode-src, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        # Build the OpenCode CLI from source on each platform.
        packages.opencode = pkgs.buildGoModule {
          pname = "opencode";                             # Package name in Nix
          version = "unstable-${opencode-src.rev or "dev"}"; # Helpful version tag

          # Use upstream git repo fetched by the input above.
          src = opencode-src;

          # If OpenCode’s Go module isn’t at repo root, set subdir = "path";
          # Otherwise leave it out. We’ll start with the repo root.
          # subdir = ".";

          # Nix must vendor Go deps. Start with a fake hash; Nix will tell you the real one.
          vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

          # If opencode builds multiple binaries, you can list subPackages (e.g. [ "cmd/opencode" ]).
          # If the main module builds a single "opencode" binary, omit this.
          # subPackages = [ "." ];

          # Optional: strip symbols; tiny binaries. Safe to leave as-is.
          ldflags = [ "-s" "-w" ];

          # If upstream needs extra tools (e.g. "make", "node", "bun"), add them here.
          nativeBuildInputs = [ ];
        };

        # Expose a Home Manager module from this nested flake.
        homeManagerModules.default = { config, lib, pkgs, ... }:
          let
            cfg = config.programs.opencode;
          in
          {
            options.programs.opencode = {
              enable = lib.mkEnableOption "OpenCode terminal assistant";

              package = lib.mkOption {
                type = lib.types.package;
                default = self.packages.${system}.opencode;
                description = "Which opencode package to install.";
              };

              # Put any settings you want in here; we’ll write them to ~/.config/opencode/config.json
              settings = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = "OpenCode global config (written to XDG config).";
              };
            };

            config = lib.mkIf cfg.enable {
              home.packages = [ cfg.package ];

              # Materialize ~/.config/opencode/config.json from the attrset.
              xdg.configFile."opencode/config.json".text =
                builtins.toJSON cfg.settings;
            };
          };
      });
}
