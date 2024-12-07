{ config, pkgs, ... }: { # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.niel = {
    isNormalUser = true;
    description = "Daniel Tumaini";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "adbusers" "libvirtd" "vboxusers" "aria2" ];

    nixpkgs.config = {
        # Allow unfree packages
        allowUnfree = true;
    };

    packages = with pkgs; [
      ### for proper neovim functioning ###
      lua-language-server
      stylua
      rust-analyzer
      ripgrep
      lemminx
      #####################################

      ###### hacking and forensics ######
      ### forensic and recovery tools
      sleuthkit # for forensics of disks
      foremost # recover files based on contents
      scalpel # recover files based on headers/footers
      ### Network scanning tools
      nmap # network scanner tool
      angryipscanner # fast and friendly network scanner
      fping # ICMP packets to multiple hosts
      netcat-gnu # remote command execution
      ### Vulnerability scanning tools
      nikto # server scanner
      ### Password cracking tools
      john # john-the-ripper
      hashcat # other password crackers
      aircrack-ng # wireless tools
      thc-hydra
      hydra-cli # parallelized network login cracker tools
      medusa # another parallel login cracker tool
      sherlock # social media hunt
      ### Explpoitation tools
      metasploit # penetration testing framework
      burpsuite # security testing of web applications
      powersploit # powershell exploitation
      sqlmap # SQL injection
      armitage # GUI for metasploit
      zap # penetration testing
      ### Packet sniffing
      wireshark
      termshark # wifi penetration
      tcpdump # network sniffer
      ettercap
      bettercap # MITM
      snort # IDS and IPS
      ngrep # packets grep-ing
      networkminer # network forensics analysis
      hping # packets assembler/analyzer
      ### wireless hacking tools
      wifite2
      reaverwps-t6x # attack against WPS
      kismet # wireless network sniffer
      bully # retrieve WPA passphrase from WPS
      cowpatty # offline dictionary attack against WPA
      ### social engineering tools
      social-engineer-toolkit
      maltego # intelligence gathering
      theharvester # gather Emails, names from different public sources
      ### reverse engineering
      ghidra # software reverse engineering by NSA Research directorate
      apktool # reverse engineering android apk files
      frida-tools # Dynamic instrumentation toolkit for reverse-engineers,
      cutter
      rizin # open source reverse engineering powered by rizin
      radare2 # unix-like reverse engineering
      jadx # Dex to Java decompiler
      ### password and encryptions
      diceware # generate random passphrase
      gnupg # gpg
      gpg-tui # gpg terminal UI
      gpgme # something something manage keys
      libgpg-error
      libgcrypt
      pinentry # for GUI pin entry
      gnuk # GNU privacy guard
      ### steganography
      steghide # hide data inside picture or audio file
      stegseek # seek hidden data inside picture or audio file
      ### metadata
      exiftool
      ###########################

    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "niel";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

}

