{ config, lib, name, pkgs, ... }:
{
  options = {
    package = lib.mkPackageOption pkgs "python313Packages.mcp" { };
    message = lib.mkOption {
      type = lib.types.str;
      default = "All your model context, are belong to us!";
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
