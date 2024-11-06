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
        pkgs = import nixpkgs {
          inherit system;
          allowUnfree = true;
        };
      in
      {
        lib = {
          gfxwrap = import ./lib/gfxwrap.nix { inherit pkgs; };
        };

        packages = {
          mpv-nonixos = pkgs.buildEnv {
            name = "mpv-nonixos";
            paths = [
              pkgs.mpv
              (self.lib.${system}.gfxwrap "mpv" "${pkgs.mpv}/bin/mpv")
            ];
          };

          jellyfin-mpv-shim = pkgs.jellyfin-mpv-shim.override {
            mpv = self.packages.${system}.mpv-nonixos;
          };

          discord-openasar = pkgs.discord.override {
            withOpenASAR = true;
          };

          tools = pkgs.buildEnv {
            name = "tools";
            paths = with pkgs; [
              fd
              biome
              nix-direnv
              nixfmt-rfc-style
              ruff
              yq
              httpie
            ];
          };
        };
      }
    );
}
