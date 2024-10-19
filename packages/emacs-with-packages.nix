{
  emacsPackagesFor,
  emacs,
}:
(emacsPackagesFor emacs).emacsWithPackages (
  epkgs: with epkgs; [
    cape
    consult
    corfu
    elfeed
    embark
    embark-consult
    envrc
    magit
    marginalia
    markdown-mode
    nix-mode
    orderless
    org
    puni
    prettier
    reformatter
    rust-mode
    treesit-auto
    vterm
    yaml-mode
    aggressive-indent
    (treesit-grammars.with-grammars (
      gram: with gram; [
        tree-sitter-bash
        tree-sitter-dockerfile
        tree-sitter-java
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-rust
        tree-sitter-tsx
        tree-sitter-typescript
      ]
    ))
  ]
)
