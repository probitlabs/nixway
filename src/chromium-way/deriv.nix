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
        inherit (pkgs) fish;
        builder = builtins.toFile "builder.sh" ''
            source $stdenv/setup

            fish $init
        '';

        #echo "===\nBootstrapping GN…" >&2
        #
        init = builtins.toFile "init.fish" ''
            echo == SETUP ==
            set awkXpr \
              '{print $3;}' \
              'BEGIN {FS = "=";} $1 == "PATH" {print $2;}' \
              'gsub(/\"/, "", $0) {print $0;}' \
              'BEGIN {FS = ":";} gsub(FS, " ", $0) {print "set", "-gx", "PATH", $0;}'
            set awkRes (awk $awkXpr[1] ./env-vars \
              | awk $awkXpr[2] \
              | awk $awkXpr[3] \
              | awk $awkXpr[4])
            echo "$awkRes" | source
            echo == /SETUP "|PATH" == >&2
            echo $PATH
            echo == /PATH == >&2

            echo == CONF == >&2
            fish ${configurePhase}
            echo == /CONF "|BUILD" == >&2
            fish ${buildPhase}
            echo == /BUILD == >&2
        '';

        configurePhase = builtins.toFile "conf.fish" ''
            set OzArgs "is_debug=false" \
              "use_ozone=true" \
              "enable_mus=true" \
              "use_xkbcommon=true"
            set OzArgs1 "$OzArgs"
            echo === Calling GN… >&2
            cd $src
            #python2 ./tools/gn/bootstrap/bootstrap.py -v -s --no-clean
            gn args --args=$OzArgs1 ./out/Ozone 
        '';

        buildPhase = builtins.toFile "build.fish" ''
            ninja -C $src/out/Ozone chrome
        '';

        nativeBuildInputs = with pkgs // pkgs.python2Packages; [
            fish gn ninja
            which python perl pkgconfig ply jinja2 nodejs gnutar
        ];
    };
}
