{
  inputs = { };
  outputs = _: {
    nixosModules.weeee = ./default.nix;
  };
}
