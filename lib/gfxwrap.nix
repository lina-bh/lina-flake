# relentlessly cribbed from
# https://github.com/nix-community/nixGL/blob/main/nixGL.nix
{
  pkgs,
  lib ? pkgs.lib,
}:
(
  name: path:
  pkgs.hiPrio (
    let
      icds = pkgs.runCommand "icds" { } ''
        find "${pkgs.mesa.drivers}/share/vulkan/icd.d" -type f -iregex '.+\.json$' \
        | tr '\0' ':' \
        | sed 's/:$/\n/' \
        > $out
      '';
    in
    pkgs.writeScriptBin name ''
      #!${lib.getExe pkgs.dash}
      export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
      export VK_ICD_FILENAMES="''$(cat ${icds})''${VK_ICD_FILENAMES:+:$VK_ICD_FILENAMES}"
      export LIBGL_DRIVERS_PATH="${lib.makeSearchPathOutput "lib" "lib/dri" [ pkgs.mesa.drivers ]}"
      export LIBVA_DRIVERS_PATH="${
        lib.makeSearchPathOutput "out" "lib/dri" (
          with pkgs;
          [
            mesa.drivers
            intel-media-driver
          ]
        )
      }"
      export LD_LIBRARY_PATH="${
        lib.makeLibraryPath (
          (with pkgs; [
            mesa.drivers
            libglvnd
            zlib
            libdrm
            wayland
            gcc.cc
          ])
          ++ (with pkgs.xorg; [
            libX11
            libxcb
            libxshmfence
          ])
        )
      }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec "${path}" "$@"
    ''
  )
)
