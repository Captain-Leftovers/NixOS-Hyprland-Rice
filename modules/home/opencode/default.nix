{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "opencode";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    rev = "v${version}";
    hash = "sha256-vXIdh1A7gM9aweZriHAq3dk1gI69yx9T2WlB/+v5Iqs=";
  };

  meta = {
    description = "AI coding agent, built for the terminal";
    homepage = "https://github.com/sst/opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "opencode";
    platforms = lib.platforms.all;
  };
}
