{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) map;
  inherit (lib.modules) mkOption;
  inherit (lib.types) listOf package attrs attrsOf;
  users = builtins.attrNames config.hrmm;

  packageOpts = { name, ... }: {
    package = mkOption {
      type = package;
      default = pkgs.${name};
      description = ''
        The package to wrap. Defaults to the attribute's name.
      '';
    };
    flags = mkOption {
      type = listOf lib.types.str;
      description = ''
        Flags to prepend to the wrapper. This is how you would want to configure
        programs, using e.g. `--config`.
      '';
    };
    env = mkOption {
      type = attrs;
      description = ''
        Environment variables that should be visible to the wrapper.
      '';
    };
    paths = mkOption {
      type = listOf package;
      description = ''
        Extra packages to add to $PATH.
      '';
    };
  };
  hrmmOpts = { ... }: {
    options = {
      packages = mkOption {
        type = attrsOf packageOpts;
        description = ''
          Set of packages to be made available in `hrmm.<user>.pkgs`. You want
          to define wrappers here and add their resultant derivations to
          `users.users.<user>.packages` using `hrmm.<user>.pkgs`.
        '';
      };
      # TODO
      files = mkOption {
        type = attrs;
        # TODO: "Symlink into"?
        description = ''
          Files to symlink into the user's $HOME directory.
        '';
      };
    };
  };

  mkPackages = user: {
    ${user}.pkgs = builtins.mapAttrs (name: value:
      let
        flagArgs = map (arg:
          [ "--add-flags" (lib.strings.escapeShellArg arg) ]) value.flags;
        envArgs = lib.attrsets.mapAttrsToList (name: value:
          [ "--set" name value ]) value.env;
        pathArgs = map (arg:
          [ "--prefix" "PATH" ":" "${arg}/bin" ]) value.paths;
        args = lib.strings.escapeShellArgs (envArgs + flagArgs + pathArgs);
      in
      pkgs.symlinkJoin {
        inherit (value.package) name;
        paths = [ value.package ] ++ value.paths;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          for file in "$out"/bin/*; do
            wrapProgram "$file" ${args}
          done
        '';
      }) config.hrmm;
  };
in {
  options.hrmm = mkOption {
    type = attrsOf (lib.types.submodule hrmmOpts);
  };
  config = {
    hrmm = map mkPackages users;
  };
}
