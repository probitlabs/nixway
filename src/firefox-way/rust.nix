{
    nightlyExpr = with getDailySet "nightlyExpr"; ghFetch {
        owner = "solson";
        repo = "rust-nightly-nix";
        inherit rev; inherit sha256;
    };
    nightlyPkg = pkgs.callPackage src {};
    mkNightlyPkg = pkg: let
        byI = getDailyByI "rust";
    in nightlyExpr.pkg.${pkg} {
        date = formatDate "-" (byI 0);
        hash = byI 1;
    };
}
