{
  pkgs,
  emacs,
  emacsPackagesFor,
}:
rec {
  emacs-with-packages = import ./emacs-with-packages.nix {
    inherit emacs emacsPackagesFor;
  };

  emacs-with-tools = import ./emacs-with-tools.nix {
    inherit pkgs emacs-with-packages;
  };
}
