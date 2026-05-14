{
  description = "Pipekit CLI — Nix flake interface to the NUR repo";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        });
    in
    {
      packages = forAllSystems ({ pkgs, ... }: rec {
        pipekit = pkgs.callPackage ./pkgs/pipekit { };
        default = pipekit;
      });
    };
}
