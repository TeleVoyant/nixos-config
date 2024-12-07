
{ config, pkgs, ... }:

{
  # --------------------------------------
  # List of services that are to be set up:
  # --------------------------------------

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
    # rpcSecretFile = "/home/niel/Downloads/Aria2/secrets/aria2-rpc-token.txt";
    extraArguments = "--rpc-listen-all --remote-time=true";
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
  #  enable = true;
  #  enableExtensionPack = true;
  #  #enableWebService = true;
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

