{
  description = "Contains missing nvidia drivers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
      in {
        packages.librdmacm = pkgs.clangStdenv.mkDerivation {
          pname = "librdmacm";
          version = "1.16.0";
          src = nixpkgs.legacyPackages.x86_64-linux.fetchFromGitHub {
            owner = "ofiwg";
            repo = "librdmacm";
            rev = "37ae092e626d9cc58a888eedca44f21ccdd7632a";
            sha256 = "";
          };

          cmakeFlags = [ ];
          nativeBuildInputs = [ pkgs.cmake pkgs.makeWrapper pkgs.glib ];
          buildInputs = [ ];

          buildPhase = ''
            ./autogen.sh
            ./configure.sh
            make
          '';
          installPhase = ''
            mkdir -p $out/
            cp -r build/** $out
          '';
        };
      });
}
