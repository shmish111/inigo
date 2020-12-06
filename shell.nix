let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };
  idris2 = import ./nix/idris2.nix { inherit sources; };
  # We are not using this right now but may need to when things are not upstreamed and we want to continue dev
  customIdris2Api = with pkgs;
    stdenv.mkDerivation rec {
      name = "idris2api";
      src = sources.Idris2;
      buildPhase = ''
        make src/IdrisPaths.idr
        ${idris2}/bin/idris2 --build ${name}.ipkg
      '';
      installPhase = ''
        mkdir $out
        cp -R ./build/ttc/* $out/
      '';
    };
  packages = import sources.smoke-hill { inherit idris2; };
  # Create an idris2 executable that has access to the required libraries
  exampleIdrisWithPackages = with packages;
    withPackages [ idris2 ];
in with pkgs; mkShell { buildInputs = [ gmp chez exampleIdrisWithPackages nodejs ]; }
