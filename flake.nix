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
            (multiService ./hello.nix)
          ];

          services.ollama."ollama1".enable = true;
          services.hello = {
            hello1 = {
              enable = true;
              message = "Hello, world!";
            };
            hello2 = {
              enable = true;
              message = "Hello, Nix!";
            };
          };
        };
      };
    };
}
