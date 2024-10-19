{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      emacs-overlay,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        emacsPackagesFor = emacs-overlay.lib.${system}.emacsPackagesFor;
        emacs = emacs-overlay.packages.${system}.emacs-pgtk;
      in
      rec {
        lib = {
          gfxwrap = import ./lib/gfxwrap.nix { inherit pkgs; };
        };

        packages =
          {
            mpv-nonixos = pkgs.buildEnv {
              name = "mpv-nonixos";
              paths = [
                pkgs.mpv
                (lib.gfxwrap "mpv" "${pkgs.mpv}/bin/mpv")
              ];
            };
          }
          // import ./packages {
            inherit pkgs emacsPackagesFor emacs;
          };
      }
    );
}
