{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.niel = {
    isNormalUser = true;
    description = "Daniel Tumaini";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "adbusers" "libvirtd" "vboxusers" "aria2" ];
    packages = with pkgs; [
      lua-language-server
      stylua
      rust-analyzer
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "niel";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

}

