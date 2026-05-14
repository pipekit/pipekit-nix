{ pkgs ? import <nixpkgs> { } }:

{
  pipekit = pkgs.callPackage ./pkgs/pipekit { };
}
