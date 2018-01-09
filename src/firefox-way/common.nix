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
    llvm = with pkgs.llvmPackages; {
        unC = clang-unwrapped;
        wpC = clang;
    };
in rec {
    firefoxWay = {
        name = "${productName}-way-${formatDate "" date}";

  	src = stranskySrc;

  	NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss";

        builder = builtins.toFile "builder.sh" ''
            #!/bin/bash
            source $stdenv/setup
            cp -r $src stransky
            chmod -R u+rw stransky
            cd stransky
            echo "$configureFlags" >> ./.mozconfig
            ./mach build
        '';

        configureFlags = with llvm; ''
            ac_add_options --with-libclang-path=${unC}/lib
            ac_add_options --with-clang-path=${wpC}/bin/clang
            ac_add_options --disable-gconf
            ac_add_options --enable-debugging
            ac_add_options --enable-profiling
        '';

        buildInputs = []
            #++ [clang]
            ++ (with pkgs; [
                dbus dbus_glib
                zip gnused 
                gcc perl python
                gtk2 gtk3
                yasm mesa libpng
                xorg.libX11 xorg.libXi xorg.libXrender xorg.libXft xorg.libXt
                kerberos fontconfig
                alsaLib libpulseaudio
                gstreamer gst-plugins-base
                sqlite unzip libevent
                libstartup_notification
                cairo autoconf213
                pkgconfig
                latest.rustChannels.nightly.rust
                libnotify
            ])
        ;

        nativeBuildInputs = with pkgs; [
            gnused which python
        ];
    };
}
