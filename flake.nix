{
  inputs = { };
  outputs = _: {
    nixosModules.weeee = ./default.nix;
    lib = pkgs: {
      mkPackages = user: builtins.map (p:
        let
          inherit (pkgs) lib;
          flagArgs = map (arg: [
            "--add-flags"
            (lib.strings.escapeShellArg arg)
          ]) p.flags;
          envArgs = lib.attrsets.mapAttrsToList (name: value: [
            "--set"
            name
            value
          ]) p.env;
          pathArgs = [
            "--prefix"
            "PATH"
            ":"
            (lib.strings.makeBinPath p.paths)
          ];
          args = lib.strings.escapeShellArgs (envArgs ++ flagArgs ++ pathArgs);
        in
        pkgs.symlinkJoin {
          inherit (p.package) name;
          paths = [ p.package ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            for file in "$out"/bin/*; do
              wrapProgram "$file" ${args}
            done
          '';
        }) (builtins.attrValues user);
    };
  };
}
