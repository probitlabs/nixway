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
    esc = pkgs.lib.escapeShellArg;
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

        #echo "===\nBootstrapping GN…" >&2
        #python tools/gn/bootstrap/bootstrap.py -v -s --no-clean
        configureF = builtins.toFile "configure.fish" ''
            #!$fish
            echo Something…
        '';
        configurePhase = "fish=${pkgs.fish} $configureF";

        buildF = builtins.toFile "build.fish" ''
            #!$fish
            set OzArgs "is_debug=false" \
              "use_ozone=true" \
              "enable_mus=true" \
              "use_xkbcommon=true"
            set OzArgs1 (echo -n "$OzArgs")
            echo "===\nCalling GN…" >&2
            gn args out/Ozone --args="$OzArgs1" --ozone-platform=wayland
            echo "===\nCalling ninja…" >&2
            ninja -C out/Ozone chrome
        '';
        buildPhase= "fish=${pkgs.fish} $buildF";

        nativeBuildInputs = with pkgs // pkgs.python2Packages; [
            fish gn ninja
            which python perl pkgconfig ply jinja2 nodejs gnutar
        ];
    };
}
