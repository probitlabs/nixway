{
    productName ? "firefox-stransky",
    date ? ["2018" "01" "02"],
}:

with import ./lowbar.nix; let
    daily = select (import ./daily.nix) date;
    getDailySet = pk: {
        rev = e daily.nightlyExpr 0;
        sha256 = e daily.nightlyExpr 1;
    };
in rec {
    firefoxWay = {
        src = ghFetch {
            owner = "stransky";
            repo = "gecko-dev";
            rev = e daily.firefoxWay 0;
            sha256 = e daily.firefoxWay 1;
        };
        buildInputs = with pkgs; [
            gcc perl python
            makeWrapper
            gtk2 gtk3
            sqlite unzip libevent
            libstartup_notification
            cairo autoconf213
        ];
    };

    nightlyExpr = rec {
        src = with getDailySet "nightlyExpr"; ghFetch {
            owner = "solson";
            repo = "rust-nightly-nix";
            inherit rev; inherit sha256;
        };
        pk = pkgs.callPackage src {};
    };

    rust = {
      src = with g
    };
    rustPkgs = pkgs.callPackage rustNightlyNixRepo {};
    rustDate = "2018-01-01";
in stdenv.mkDerivation {
    name = "${product}-way-20180102";
    enableOfficalBranding = false;
    inherit src;
    configureFlags = (builtins.filter isntToolkit old.configureFlags) ++ [
        "--enable-default-toolkit=cairo-gtk3-wayland"
    ];
    patches = [];
    preConfigure = "./mach build";
    nativeBuildInputs = [
        (rustPkgs.rust {date = rustDate; hash = x: "1m338l4x07jy8lxr9kmq7bcg2pvymk6sqkld6haq4n8pd20wfqsd";})
        pkgs.llvmPackages.clang-unwrapped
    ] ++ old.nativeBuildInputs;
    #rustPkgs.cargo rustPkgs.rustc]);
};
 
