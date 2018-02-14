with {}
    // import <nixpkgs> {}
    // builtins
;

map stdenv.mkDerivation (
    filter
    (e: e.isDeriv or true)
    (
        attrValues
        (import ./deriv.nix pkgs {})
    )
)
