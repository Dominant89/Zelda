{
  description = "Tool to statically recompile N64 games into native executables";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs @ {...}:
    inputs.flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
      in rec {
        packages = rec {
          N64Recomp = pkgs.stdenv.mkDerivation {
            pname = "N64Recomp";
            version = "1.0.0";
            src = pkgs.fetchFromGitHub {
                  owner = "Mr-Wiseguy";
                  repo = "N64Recomp";
                  rev = "26c5c2cbb844b0f6a3f7c0d1440273e499ee2194";
                  deepClone = true;
                  fetchSubmodules = true;
                  hash = "sha256-Kw8Zdo4cbLib5L5v5meAn6gq2WEpmueNvEDTBQOtHdk=";
                };
            nativeBuildInputs = [pkgs.cmake];

            installPhase = ''
                    mkdir -p $out/bin
                    cp N64Recomp $out/bin
                    cp RSPRecomp $out/bin
                '';
          };
          default = N64Recomp;
        };
        apps = rec {
          N64Recomp = {
            type = "app";
            program = "${packages.N64Recomp}/bin/N64Recomp";
          };

          RSPRecomp = {
            type = "app";
            program = "${packages.N64Recomp}/bin/RSPRecomp";
          };
          default = N64Recomp;
        };
      }
    );
}