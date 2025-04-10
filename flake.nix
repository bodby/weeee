{
  inputs = { };
  outputs = _: {
    # FIXME: Move module.nix to default.nix.
    nixosModules.default = ./.;
  };
}
