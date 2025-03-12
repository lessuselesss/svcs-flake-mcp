{ config, lib, name, pkgs, ... }:
{
  options = {
    package = lib.mkPackageOption pkgs "hello" { };
    message = lib.mkOption {
      type = lib.types.str;
      default = "Hello, world!";
      description = "The message to be displayed";
    };
  };
  config = {
    outputs.settings = {
      processes.${name} = {
        command = "${lib.getExe config.package} --greeting='${config.message}'";
      };
    };
  };
}
