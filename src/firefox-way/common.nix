{
    productName ? "firefox-stransky",
    date ? ["2018" "01" "02"],

    officalBranding ? false,
    crashReporter ? false,
    webRtc ? true,

    geoLocation ? true,
    googleApi ? false,
    safeBrowsing ? true,
    drm ? false,

    pulseaudio ? true,
    alsa ? true,
    ffmpeg ? true,
    genericSecService ? true,
}:

with import ./lowbar.nix; let
    selectDate = select (import ./daily.nix);
    getDailyByI = key: e (selectDate date).${key};
    getDailySet = key: {
        rev = getDailyByI key 0;
        sha256 = getDailyByI key 1;
    };

in with import ./rust.nix; rec {
    firefoxWay = {
        src = with getDailySet "stransky"; ghFetch {
            owner = "stransky";
            repo = "gecko-dev";
            inherit rev; inherit sha256;
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

    rustc = {
        
    };
in stdenv.mkDerivation {
    name = "${product}-way-20180102";
    enableOfficalBranding = false;
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
 
