# About
NixOS module for configuring programs using wrappers and symlinks.

Currently broken until I finish rewriting my NixOS configuration without ever testing it. B)

## Features
- Per-user wrappers and `$HOME` symlinks.
- Works on my machine.

## Usage
Install this as you would any other NixOS module.

### Flakes
```nix
# flake.nix
{
  inputs = {
    # Use either the GitHub or Codeberg repo.
    weeee = {
      url = "git+https://github.com/bodby/weeee?shallow=1&ref=master";
      url = "git+https://codeberg.org/bodby/weeee";
    };
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
  };
  outputs = { nixpkgs, weeee, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit weeee; };
    };
  };
}
```

### No flakes[^1]
```nix
# configuration.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Use either the GitHub or Codeberg repo.
  weeee = builtins.fetchTarball "https://github.com/bodby/weeee/archives/refs/head/master.tar.gz";
  weeee = builtins.fetchTarball "https://codeberg.org/bodby/weeee/archive/master.tar.gz";
in {
  imports = [
    (import weeee)
  ];
}
```

## Resources
- [sioodmy/homix](https://github.com/sioodmy/homix)
- [viperML/wrapper-manager](https://github.com/viperML/wrapper-manager)

[^1]: I don't actually know if this is the right way to do it.
