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

    nspr = pkgs.nspr;
    nsprFlag = "-I${nspr.dev}/include/nspr";
    llvm = with pkgs.llvmPackages; {
        unC = libclang;
        wpC = clang;
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
            echo "$configureFlags" >> ./.mozconfig
            ./mach build
        '';

        configureFlags = with llvm; ''
            ac_add_options --with-libclang-path=${unC}/lib
            ac_add_options --with-clang-path=${wpC}/bin/clang
            ac_add_options --disable-gconf
            ac_add_options --enable-debug
            ac_add_options --enable-profiling
            ac_add_options --enable-jemalloc
            ac_add_options --disable-updater
            ac_add_options --disable-necko-wifi
            ac_add_options --disable-maintenance-service
            ac_add_options --disable-tests
            ac_add_options --with-system-nspr
            ac_add_options --with-system-nss 
        '';
        #            mk_add_options NIX_CFLAGS_COMPILE="${nsprFlag} $NIX_CFLAGS_COMPILE"

        buildInputs = []
            ++ (with pkgs.xorg; [
                libX11 libXi libXrender libXft libXt libXext xextproto
            ])
            ++ (with pkgs; [
                dbus dbus_glib
                zip gnused 
                gcc perl python
                gtk2 gtk3
                yasm mesa libpng
                kerberos fontconfig
                alsaLib libpulseaudio
                gstreamer gst-plugins-base
                unzip libevent
                libstartup_notification
                cairo autoconf213
                pkgconfig
                latest.rustChannels.nightly.rust
                wayland wayland-protocols xwayland
                file libnotify
                nss nspr jemalloc
                perl zlib sqlite
                rust-bindgen
            ])
        ;

        nativeBuildInputs = with pkgs; [
            gnused which python
            rust-bindgen #?
        ];
    };
}
