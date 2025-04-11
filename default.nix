{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) map;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf package attrs attrsOf submodule;
  inherit (config.weeee) users;

  packageOpts = { name, ... }: {
    options = {
      package = mkOption {
        type = package;
        default = pkgs.${name};
        description = ''
          The package to wrap. Defaults to the attribute's name.
        '';
      };
      flags = mkOption {
        type = listOf (lib.types.either lib.types.str lib.types.path);
        default = [ ];
        description = ''
          Flags to prepend to the wrapper. This is how you would want to configure
          programs, using e.g. `--config`.
        '';
      };
      env = mkOption {
        type = attrs;
        default = { };
        description = ''
          Environment variables that should be visible to the wrapper.
        '';
      };
      paths = mkOption {
        type = listOf package;
        default = [ ];
        description = ''
          Extra packages to add to $PATH.
        '';
      };
    };
  };
  userOpts = _: {
    options = {
      packages = mkOption {
        type = attrsOf (submodule packageOpts);
        description = ''
          Set of packages to be made available in `weeee.users.<user>.pkgs`. You want
          to define wrappers here and add their resultant derivations to
          `users.users.<user>.packages` using `weeee.<user>.pkgs`.
        '';
      };
      # TODO
      # files = mkOption {
      #   type = attrs;
      #   description = ''
      #     Files to symlink into the user's $HOME directory.
      #   '';
      # };
    };
  };
in {
  options.weeee.users = mkOption {
    type = attrsOf (submodule userOpts);
  };
}
