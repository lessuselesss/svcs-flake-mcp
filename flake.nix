{
  description = "A demo of importing a multi-instance custom service";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.process-compose-flake.flakeModule
      ];
      perSystem = { self', pkgs, lib, ... }: {
        process-compose."default" = 
        let
          inherit (inputs.services-flake.lib) multiService;
        in
        {
          imports = [
            inputs.services-flake.processComposeModules.default
            (multiService ./mcp-core.nix)
          ];

          services.mcp-core."mcp-server".enable = true;
          services.mcp-core = {
            fileSystem = {
              enable = true;
              message = "goodbye, disks!";
            };
            time = {
              enable = true;
              message = "Hello, Nix!";
            };
          };
        };
      };
    };
}
