{
    product ? "chromium-way",
    channel ? "stable",

    pulseSupport ? true,
    cupsSupport ? true,
    commandLineArgs ? "",
}:

pkgs:

let
    llvm = with pkgs.llvmPackages; {
        unC = clang-unwrapped;
        wpC = clang;
    };
    stdDeps = with pkgs; [
        # Compression
        bzip2 zlib snappy
        # Audio
        flac opusWithCustomModes
        # Graphics
        libpng
        # Data
        libxslt libxml2
        # Interface
        libevent
    ]
in rec {}
