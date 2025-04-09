{
  inputs = { };
  outputs = _: {
    nixosModules.default = ./module.nix;
  };
}
