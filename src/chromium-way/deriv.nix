pkgs:

{
    info ? import ./info.nix pkgs,
    meta ? import ./meta.nix pkgs,

    product ? "chromium-way",
    channel ? "stable",

    pulseSupport ? true,
    cupsSupport ? true,
    commandLineArgs ? "",
}:

let
    llvm = with pkgs.llvmPackages; {
        unC = clang-unwrapped;
        wpC = clang;
    };
    deps = with pkgs; [
        # Tooling
        yasm bison gperf kerberos icu re2 libgcrypt
        # Networking
        libnss kerberos
        # Compression
        bzip2 zlib snappy zlib minizip
        # Audio
        libpulseaudio alsaLib flac opusWithCustomModes speex
        # Graphics
        libpng libjpeg libwebp ffmpeg
        # Data
        xdg_utils libxslt libxml2
        # Interface
        dbus
        # Hardware
        libpci libcap libusb1 cups
    ];
    suffix = if channel == "stable" then "" else "-${channel}";
in {
    ozone = rec {
        name = product + suffix;
        inherit meta;

        inherit (info) src;
        #inherit (pkgs) fish;
        #builder = builtins.toFile "builder.sh" ''
        #    #!$fish
        #    source $stdenv/setup

        #    source <(echo $configurePhase)
        #    source <(echo $buildPhase)
        #'';
        configurePhase = ''
            #!${pkgs.fish}
            python tools/gn/bootstrap/bootstrap.py -v -s --no-clean
            set -x PATH $PWD/out/Release $PATH
        '';
        buildPhase = ''
            #!${pkgs.fish}
            set ozArgs is_debug=false use_ozone=true enable_mus=true use_xkbcommon=true
            gn args out/Ozone --args="$ozArgs" --ozone-platform=wayland
            ninja -C out/Ozone chrome
        '';
        nativeBuildInputs = with pkgs // pkgs.python2Packages; [
            ninja which python perl pkgconfig ply jinja2 nodejs gnutar
        ];
    };
}
