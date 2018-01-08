{
    productName ? "firefox-stransky",
    date ? ["2018" "01" "03"],

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

pkgs:

with {}
    // import ./lowbar.nix
    // import ./rust.nix date pkgs
    // import ./date.nix
;

let
    ghFetch = pkgs.fetchFromGithub;
in rec {
    firefoxWay = {
        name = "${productName}-way-${formatDate "" date}";
        src = with getDailySet date "stransky"; ghFetch {
            owner = "stransky";
            repo = "gecko-dev";
            inherit rev sha256;
        };

        builder = builtins.toFile "builder.sh" "./mach build";

        buildInputs = [
            rustc cargo
        ] ++ (with pkgs; [
            gcc perl python
            makeWrapper
            gtk2 gtk3
            sqlite unzip libevent
            libstartup_notification
            cairo autoconf213
        ]);
    };

    rustc = mkNightlyPkg "rustc";
    cargo = mkNightlyPkg "cargo";
}
