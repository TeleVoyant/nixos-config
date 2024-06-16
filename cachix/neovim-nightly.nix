
{
  nix = {
    settings = {
      substituters = [
        "https://neovim-nightly.cachix.org"
      ];
      trusted-public-keys = [
        "neovim-nightly.cachix.org-1:feIoInHRevVEplgdZvQDjhp11kYASYCE2NGY9hNrwxY="
      ];
    };
  };
}
