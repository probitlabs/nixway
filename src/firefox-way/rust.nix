with {}
    // import ./lowbar.nix
    // import ./date.nix
;

date:
pkgs:

rec {
    nightlyExpr = with getDailySet date "nightlyExpr"; pkgs.fetchFromGitHub {
        owner = "solson";
        repo = "rust-nightly-nix";
        inherit rev; inherit sha256;
    };
    nightlyPkg = pkgs.callPackage nightlyExpr {};
    mkNightlyPkg = pkg: let
        byI = getDailyByI date pkg;
    in nightlyPkg.${pkg} ({}
        // {date = formatDate "-" (byI 0).just;}
        // (
            if (byI 1).nothing or false
            then {}
            else {hash = (byI 1).just;}
        )
    );
}
