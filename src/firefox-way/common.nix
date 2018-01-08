{
    productName ? "firefox",
    date ? "2018-01-01",
}:

let
    src = pkgs.fetchFromGitHub {
        owner = "stransky";
        repo = "gecko-dev";
        inherit rev;
        inherit sha256;
    };
    isntToolkit = (flag:
        builtins.substring 0 25 flag != "--enable-default-toolkit"
    );

    rustNightlyNixRepo = pkgs.fetchFromGitHub {
        owner = "solson";
        repo = "rust-nightly-nix";
        rev = "9e09d579431940367c1f6de9463944eef66de1d4";
        sha256 = "03zkjnzd13142yla52aqmgbbnmws7q8kn1l5nqaly22j31f125xy";
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
}
 
