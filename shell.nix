{
  mkShellNoCC,
  nixd,
  statix,
  nurl,
}:
mkShellNoCC {
  name = "nix";
  packages = [
    nixd
    statix
    nurl
  ];
}
