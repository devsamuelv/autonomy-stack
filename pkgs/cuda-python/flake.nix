{
  description = "cuda-python";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
      in {
        package.default = 

        packages.cuda-bindings = pkgs.python3Packages.buildPythonPackage rec {
          pname = "cuda-python";
          version = "1.16.0";
          format = "pyproject";

          src = pkgs.fetchzip rec {
            owner = "NVIDIA";
            repo = "cuda-python";
            rev = "73ab82f8219abbc2d2305cd25f9286abccbe5326";
            sha256 = "";
          };

          cmakeFlags = [ ];
          nativeBuildInputs = [ pkgs.cmake pkgs.makeWrapper pkgs.glib ];
          buildInputs = [ ];

          buildPhase = ''
            cd cuda_bindings
          '';
          installPhase = ''
            mkdir -p $out/
            cp -r build/** $out
          '';
        };
      });
}
