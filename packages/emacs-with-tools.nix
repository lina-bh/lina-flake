{
  pkgs,
  emacs-with-packages,
  lib ? pkgs.lib,
}:
let
  make-emacs-wrapper = pkgs.hiPrio (
    pkgs.runCommand "make-emacs-wrapper"
      {
        nativeBuildInputs = [
          pkgs.makeWrapper
        ];
      }
      ''
        for emacs in "${emacs-with-packages}/bin"/emacs*; do
          makeWrapper "$emacs" "''${out}/bin/''$(basename "$emacs")" \
            --suffix PATH : "${
              lib.makeBinPath (
                with pkgs;
                [
                  ripgrep
                  nixfmt-rfc-style
                  taplo
                ]
              )
            }"
        done
        makeWrapper "${lib.getExe pkgs.nodejs}" "''${out}/bin/node" \
          --set-default NODE_PATH "${pkgs.nodePackages.prettier}/lib/node_modules"
      ''
  );
in
pkgs.buildEnv {
  name = "emacs-with-tools";
  paths = [
    emacs-with-packages
    make-emacs-wrapper
  ];
}
