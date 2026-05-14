# pipekit-nix

Interim Nix distribution channel for the [Pipekit](https://pipekit.io/) CLI,
also registered with [NUR](https://github.com/nix-community/NUR) for discovery.

The primary install path is [nixpkgs](https://github.com/NixOS/nixpkgs):

```sh
nix profile install nixpkgs#pipekit
```

This repo exists because nixpkgs bumps lag CLI releases by a few days — a
goreleaser publisher writes `pkgs/pipekit/default.nix` here on every release of
[pipekit/cli](https://github.com/pipekit/cli), so users who need the newest CLI
ahead of the nixpkgs bump can install directly from this repo (via flake input
or the NUR overlay).

## Unfree license

The Pipekit CLI is proprietary, so the derivation is marked `unfree`. Opt in
before installing:

```sh
export NIXPKGS_ALLOW_UNFREE=1
```

or, in your NixOS / home-manager config:

```nix
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (pkgs.lib.getName pkg) [ "pipekit" ];
```

## Install

### Via NUR

Once your system has the NUR overlay configured, the CLI is available as
`pkgs.nur.repos.pipekit.pipekit`:

```nix
environment.systemPackages = [ pkgs.nur.repos.pipekit.pipekit ];
```

See the [NUR README](https://github.com/nix-community/NUR#installation) for
overlay setup.

### Flake input

```nix
{
  inputs.pipekit-cli.url = "github:pipekit/pipekit-nix";

  outputs = { self, nixpkgs, pipekit-cli, ... }: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            pipekit-cli.packages.${pkgs.system}.pipekit
          ];
        })
      ];
    };
  };
}
```

### Ad-hoc

```sh
nix profile install github:pipekit/pipekit-nix
# or
nix run github:pipekit/pipekit-nix -- --help
```

## NUR registration

This repo is listed in [`nix-community/NUR`](https://github.com/nix-community/NUR)
under the `pipekit` entry in `repos.json`. NUR's CI re-evaluates on every push
and serves the package through the overlay.

## Releases

Every tagged release of [pipekit/cli](https://github.com/pipekit/cli) pushes an
updated `pkgs/pipekit/default.nix` to this repo via goreleaser's `nix`
publisher. `pkgs/pipekit/default.nix` is generated; do not edit it by hand.
