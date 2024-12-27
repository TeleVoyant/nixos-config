# default.nix
let
  # Import nixpkgs with config allowing unfree packages
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  };
in
pkgs.callPackage ./bitwig-studio.nix {}
