# About
NixOS module for configuring programs using wrappers and symlinks.

In other words, an inferior and "minimalist" Home Manager.

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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Use either the GitHub or Codeberg repo.
    weeee = {
      url = "github:bodby/weeee";
      url = "git+https://codeberg.org/bodby/weeee";
    };
  };
  outputs = { nixpkgs, weeee, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit weeee; };
    };
  };
}
```

### No flakes
I don't actually know if this is the right way to do it.

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
