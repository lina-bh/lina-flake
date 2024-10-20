{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        lib = {
          gfxwrap = import ./lib/gfxwrap.nix { inherit pkgs; };
        };

        packages = {
          mpv-nonixos = pkgs.buildEnv {
            inherit (pkgs.mpv) version;
            name = "mpv-nonixos";
            paths = [
              pkgs.mpv
              (lib.gfxwrap "mpv" "${pkgs.mpv}/bin/mpv")
            ];
          };
        };
      }
    );
}
