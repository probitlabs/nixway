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
    // import ./date.nix
;

let
    stranskySrc = with getDailySet date "stransky"; pkgs.fetchFromGitHub {
        owner = "stransky";
        repo = "gecko-dev";
        inherit rev sha256;
    };
in rec {
    firefoxWay = {
        name = "${productName}-way-${formatDate "" date}";
        src = stranskySrc;

        builder = builtins.toFile "builder.sh" ''
            #!/bin/bash
            source $stdenv/setup
            cp -r $src stransky
            chmod -R u+rw stransky
            cd stransky
            ./mach build
        '';

        buildInputs = with pkgs; [
            latest.rustChannels.nightly.rust
            gcc perl python
            makeWrapper
            gtk2 gtk3
            sqlite unzip libevent
            libstartup_notification
            cairo autoconf213
        ];

        nativeBuildInputs = with pkgs; [
            gnused which perl python
            latest.rustChannels.nightly.rust
        ];
    };
}
