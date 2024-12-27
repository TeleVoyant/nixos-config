# These are dependencies that this package needs,
# of which, Nix will provide
{
  stdenv,
  fetchurl,
  alsa-lib,
  atk,
  cairo,
  gnutar,
  unzip,
  dpkg,
  ffmpeg,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  lib,
  libglvnd,
  libjack2,
  libjpeg,
  libxkbcommon,
  makeWrapper,
  pango,
  pipewire,
  pulseaudio,
  vulkan-loader,
  wrapGAppsHook3,
  xcb-imdkit,
  xdg-utils,
  xorg,
  zlib,
}:

# actual package definition.
# mkDerivation is the main function used to build packages in Nix.
# rec means this is a recursive set, allowing attributes to reference each other.
stdenv.mkDerivation rec {
  pname = "bitwig-studio";
  version = "5.2.0";

  # This downloads the Bitwig installer (from internet archive)
  # The hash ensures the downloaded file matches exactly what's expected
  src = fetchurl {
    url = "https://ia801006.us.archive.org/zip_dir.php?path=/23/items/bitwig.-studio.v-5.2.0.-li-nux-flare.tar.zip";
    hash = "sha256-inumRTuqk791GmdSs9VfIFhE3kOeGWsNaiAUrPrsYjY=";
  };

  # tools needed during the build process
  nativeBuildInputs = [
    gnutar
    unzip
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  # Extract the tarball and then, extract debian contents to root
  unpackCmd = ''
    # Create a single source directory
    mkdir root

    # Extract the downloaded archive directly on current directory
    unzip $curSrc

    # Locate the .tar.xz file
    tarfile=$(find . -name '*.tar.xz')
    if [ -z "$tarfile" ]; then
      echo "Error: .tar.xz file not found"
      exit 1
    fi

    # Extract the tarball
    tar xf "$tarfile"

    # Locate the .deb file
    debfile=$(find . -name '*.deb')
    if [ -z "$debfile" ]; then
      echo "Error: .deb file not found"
      exit 1
    fi

    # Extract the deb contents
    dpkg-deb -x "$debfile" root
    echo "Extraction complete."
    echo "Contents of $(pwd):"
    ls -al
    cd root
    echo "Contents of $(pwd):"
    ls -al
  '';

  # directory to focus on
  sourceRoot = "/build/root";

  # flags to skip certain default build steps since its a pre-built binary package.
  dontBuild = true;
  dontWrapGApps = true;

  # runtime dependencies that Bitwig needs
  buildInputs = with xorg; [
    alsa-lib
    atk
    cairo
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libglvnd
    libjack2
    libjpeg
    libxcb
    libXcursor
    libX11
    libXtst
    libxkbcommon
    pango
    pipewire
    pulseaudio
    (lib.getLib stdenv.cc.cc)
    vulkan-loader
    xcb-imdkit
    xcbutil
    xcbutilwm
    zlib
  ];

  # copy files into their final locations
  installPhase = ''
    runHook preInstall

    # Create necessary directories in the output
    mkdir -p $out/bin

    # Copy the extracted files
    cp -r opt/bitwig-studio $out/libexec
    ln -s $out/libexec/bitwig-studio $out/bin/bitwig-studio
    cp -r usr/share $out/share
    # using libxcb shipped with nixpkgs
    rm -f $out/libexec/lib/bitwig-studio/libxcb-imdkit.so.1

    # Adjust the desktop entry to point to the correct executable
    substitute usr/share/applications/com.bitwig.BitwigStudio.desktop \
      $out/share/applications/com.bitwig.BitwigStudio.desktop \
      --replace /usr/bin/bitwig-studio $out/bin/bitwig-studio

    # New operations for JAR replacement
    echo "patching bitwig.jar file"
    mv $out/libexec/bin/bitwig.jar $out/libexec/bin/bitwig.orig.jar
    cp /build/Bitwig.Studio.v5.2.0.LiNUX-FLARE/FLARE/bitwig.jar $out/libexec/bin/bitwig.jar

    runHook postInstall
  '';

  # the fix-up phase,
  # Finds all executable files, Sets the correct dynamic linker
  # Wraps the executables with correct environment variables
  # Sets up library paths and dependencies
  postFixup = ''
    # postFixup operations
    find $out -type f -executable \
      -not -name '*.so.*' \
      -not -name '*.so' \
      -not -name '*.jar' \
      -not -name 'jspawnhelper' \
      -not -path '*/resources/*' | \
    while IFS= read -r f ; do
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
      wrapProgram $f \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
        --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
        --suffix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath buildInputs}"
    done

    find $out -type f -executable -name 'jspawnhelper' | \
    while IFS= read -r f ; do
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
    done
  '';

  # metadata about the package:
  # description, license, supported platforms, and maintainers.
  meta = with lib; {
    description = "Digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = "https://www.bitwig.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      bfortz
      michalrus
      mrVanDalo
      TeleVoyant
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
