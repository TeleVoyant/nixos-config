
{ config, pkgs, ... }:

{
  # --------------------------------------
  # List of services that are to be set up:
  # --------------------------------------
  # Extra crucial xserver options
  services.xserver = {
    # Enable the X11 windowing system
    enable = true;
    
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Load video drivers (default and/or nvidia)
    videoDrivers = [ "nvidia" ];

    # Configure keymap in X11
    xkb.layout = "gb";
    #xkb.Variant = "";

  };
  
  # pipewire service configuration:
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
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  
  # Enable flathub
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable OpenSSH daemon
  services.openssh.enable = true;

  # Enable deluge services
  services.deluge = {
    enable = true;
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  # Enable aria2 daemon and ports
  services.aria2 = {
    enable = true; #Enable aria2 daemon
    openPorts = true; #Open firewall for ports
    rpcSecretFile = "/home/niel/Downloads/Aria2/secrets/aria2-rpc-token.txt";
  };

  # Enable rsync daemon and activations
  services.rsyncd = {
    enable = true; #Enable rsync service
    socketActivated = true; #more efficient
  };

  # enable dict service
  services.dictd = {
    enable = true;
  };


  # --------------------------------------
  # List of virtualizations to be set up:
  # --------------------------------------

  # enable docker virtualization
  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # enable virtualbox and its extension packs
  # Virtualbox configuration
  #virtualisation.virtualbox.host = {
  # enable = true;
  # enableExtensionPack = true;
  # #enableWebService = true;
  #};


  # --------------------------------------
  # List of programs that are to be set up:
  # --------------------------------------

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = true;
    enableExtraSocket = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # favourite web browser
  programs.firefox.enable = true;

  # Enable adb for android debug
  programs.adb = {
    enable = true;
  };

}

