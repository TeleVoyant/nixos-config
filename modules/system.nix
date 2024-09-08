{ config, pkgs, ... }:

{
  # if you encounter problem of booting to text mode, uncomment these
  #boot.initrd.kernelModules = [ "nvidia" ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # load ntfs support from boot
  boot.supportedFilesystems = [ "ntfs" ];


  # Set your time zone.
  time.timeZone = "Africa/Dar_es_Salaam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Configure console keymap
  #console.keyMap = "uk";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # nix settings
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # save each configuration file under generation dir
  system.copySystemConfiguration = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false; # we will use pipewire instead
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # would be to create a swapfile:
  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024; # 32GB
  }];


  # nix packages extra configurations
  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;

    #Allow Old unmainttained
    #allowBroken = true;

    # Accept Nvidia license
    nvidia.acceptLicense = true;

    # Accept virtualbox license
    virtualbox.acceptLicense = true;

    #permitted insecure packages
    permittedInsecurePackages = [
      #"qtwebkit-5.212.0-alpha4"
      #"electron-25.9.0"
    ];

    # neovim nightly
    packageOverrides = pkgs: let
        pkgs' = import <nixos-unstable> {
            inherit (pkgs) system;
            overlays = [
                (import (builtins.fetchTarball {
                         url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
                         }))
            ];
        };
    in {
        inherit (pkgs') neovim;
    };
  };
  #################################


  # List of Overlays, containing configuration for installing neovim's nightly packages
  #nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
  #  }))
  #];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget

    # nixos core packages
    nixos-option # extra options
    cachix # cache

    ### gnome extensions
    gnomeExtensions.mpris-label
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.easyeffects-preset-selector
    gnomeExtensions.docker
    gnomeExtensions.top-bar-organizer
    ### gnome apps
    gnome.gnome-bluetooth # bluetooth manager
    gnome.gnome-tweaks # customizing gnome
    gnome.dconf-editor # further customizations
    #gnome.gnome-terminal		# giving 'console' a chance
    gnome.ghex # light HEX editor


    # bin utils
    exfat # for exfat manipulation
    gcc
    libgcc
    gdb
    gnumake
    cmakeWithGui
    gf # GNU c/c++
    flex
    bison
    bisoncpp
    flexcpp
    re-flex # parser generator
    llvmPackages_17.libclang
    llvmPackages_17.clang-manpages # corporate c/c++
    llvmPackages_17.libllvm
    llvmPackages_17.llvm-manpages # corporate c/c++
    rustc
    rustup # for rust
    go # for gophers
    go-migrate # for go DB migrations
    zig # for zig
    julia # performance-oriented dynamical language
    alire # lady ada
    zulu
    maven # java utilities for libreoffice base, i promise!
    gradle
    gradle-completion # build system
    nodejs_20 # node and npm
    erlang
    rebar3
    elixir # erlang and elixir tools
    php83
    php83Packages.composer # php 8.3
    python312Full
    python312Packages.pip
    luajit
    luajitPackages.luarocks # JIT lua and JIT luarocks package manager
    flutter # flutter application development
    _7zz # 7zip
    zip
    unzip # zip and unzip (not same as gzip!)
    rar # utility for RAR archives
    docker
    docker-compose # containers to ship
    nvidia-container-toolkit # to build and run GPU accelerated containers.
    jp2a # jpeg to ASCII
    neofetch # system info script
    pkg-config # packages find info about other packages
    dpkg # debian package manager
    jq # cmd json processor
    openssl # cryptographic SSL and TLS library


    ########################## audio and DSPs ###########################
    ### pipewire ###
    easyeffects # pulseeffects for pipewire
    wireplumber # pipewire session & policy manager
    pipecontrol # pipewire control GUI
    qpwgraph # wire manager for pipewire
    helvum # pipewire patchbay
    carla # for interfacing plugins to pipe-jack

    ### audio plugins (VST2, VST3, LV2, LADSPA)  ###
    zam-plugins # zam-audio plugins
    tap-plugins # collection of audio processing plugins
    lsp-plugins # linux studio plugins
    infamousPlugins # another collection of audio processing plugins
    calf # calf studio gear
    libebur128 # auto gain
    zita-convolver # custom reverbs
    soundtouch # pitch, tempo
    rnnoise
    rnnoise-plugin # ML noise reduction
    noise-repellent # primitive noise reduction
    surge-XT # best opensource synth in the world
    vital # another synth
    odin2 # another synth
    dexed # another FM
    vcv-rack # rack version synth
    helm # Another synth
    geonkick # sequencer
    zynaddsubfx # realtime MIDI processor
    bespokesynth # modular synth
    oxefmsynth # another FM synth
    tunefish # another synth
    sorcer # wavetable synth
    cardinal # inspired by VCV rack
    CHOWTapeModel
    ChowCentaur
    ChowPhaser
    ChowKick # CHOW utilities
    aether-lv2 # algo reverb based on cloudseed
    distrho # collection of small plugins
    dragonfly-reverb # name explains it
    swh_lv2 # we're about to find out


    ###  DAWS ###
    bitwig-studio # not open-source DAW but amaizing
    renoise # not open-source, daw with track approach
    reaper # not open-source, way cheaper
    ardour # open-source daw
    lmms # ardour with fl-studio workflow

    ###################################################################



    # troubleshooting
    speedtest-cli # network
    btop # top system monitors on steroids
    gparted # gui partition editor
    dconf # backend to Gsettings
    wirelesstools
    iw # wireless connections
    mtr # network diagnostics tool
    pciutils # listing pci e devices
    lshw # list hardware properties

    # fonts
    corefonts # extra office fonts
    google-fonts # for office use
    vistafonts # i want 'times new roman'

    # download manager
    curl # url crawler
    wget
    wget2 # successor to wget
    aria # command-line download utility
    ariang # aria2 front-end
    yt-dlp # youtube video downloader
    deluge # torrents

    # dev env
    #neovim-nightly # TUI: 1st favourite editor (nightly builds)
    neovim # TUI: 1st favourite editor
    zed-editor # High-performance, multiplayer code editor
    geany # small, lightweight IDE
    fzf # TUI: fuzzy finder written in Go
    fzf-git-sh # TUI: key bindings for Git objects, powered by fzf.
    fd # TUI: simple, fast and user-friendly alternative to find
    bat # TUI: cat clone with wings.
    delta # TUI: diff, grep, and blame output for git
    eza # TUI: modern, maintained replacement for ls
    unixtools.xxd # hex-editor
    wl-clipboard # cli clipboard manager
    tmux # terminal multiplexer
    nerdfonts # for programming
    git # version control
    gh # git user manager
    androidStudioPackages.canary
    wxhexeditor # advanced HEX editor
    insomnia # API DevTest
    libvirt # toolkit to interact with the virtualization
    #virtualbox # GUI virtualizer
    qemu_full # machine emulator and CLI virtualizer
    #ciscoPacketTracer8

    #### RECORDING AND STREAMING ####
    obs-studio # stream/screen-capture
    obs-studio-plugins.input-overlay # keystrokes
    obs-studio-plugins.obs-gradient-source
    obs-studio-plugins.obs-backgroundremoval
    obs-studio-plugins.obs-shaderfilter
    obs-studio-plugins.obs-move-transition
    obs-studio-plugins.obs-composite-blur
    obs-studio-plugins.obs-3d-effect
    #davinci-resolve # the G.O.A.T of video editors out here
    screenkey # keystroke renderer
    kdenlive # video seq
    shotcut # another video seq

    ########### GENERAL APPLICATIONS ##############
    #kicad # 3d electronics pcb suite
    #brlcad # 3d solid works suite
    libreoffice-fresh # this is MSOffice
    openscad # programmable 3d solid works
    sca2d # programmer's 3d solid works
    kodi-wayland # media center
    blender # 3D art/ video seq
    handbrake # converting video files
    audacity # sound editor
    gimp # photoshop challenger
    krita # gimp challenger
    inkscape-with-extensions # vector graphics editor
    imagemagickBig # lightest photoshop
    darktable # lightroom challenger
    telegram-desktop # telegram chat app
    discord # discord server
    riseup-vpn # free vpn
    #goldendict # feature-rich dictionary
    goldendict-ng # the Next Generation GoldenDict.
    dict # terminal dictionary
    mpv # general-purpose media player
    rhythmbox # some music
    vlc # that one traffic cone...
    lm_sensors # sensor recapture
    firefox # favourinte fox
    chromium # not so favourite fox
    calibre # e-book software
    bibletime # bible library
    gImageReader # scan mitihani
    masterpdfeditor # edit pdf on the go
    obsidian # My notes
    #wineWowPackages.waylandFull
    #timeshift # backup home files and configurations
    vscode # forced by collaborative purposes
    httrack # website coppier

    # Nvidia specific
    #cudaPackages.cudatoolkit

  ];


}

