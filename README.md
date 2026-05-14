# nur-pipekit

[NUR](https://github.com/nix-community/NUR) repository for the [Pipekit](https://pipekit.io/) CLI.

The `pkgs/pipekit/default.nix` derivation is updated automatically by
[goreleaser](https://goreleaser.com) on every CLI release in
[pipekit/cli](https://github.com/pipekit/cli). Do not edit it by hand.

## Unfree license

The Pipekit CLI is proprietary, so the derivation is marked `unfree`. You must
opt in before installing:

```sh
export NIXPKGS_ALLOW_UNFREE=1
```

or, in your NixOS / home-manager config:

```nix
nixpkgs.config.allowUnfree = true;
# or, scoped:
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (pkgs.lib.getName pkg) [ "pipekit" ];
```

## Install

### Via NUR (recommended once registered)

Once your system has the NUR overlay set up, the CLI is available as
`pkgs.nur.repos.pipekit.pipekit`:

```nix
environment.systemPackages = [ pkgs.nur.repos.pipekit.pipekit ];
```

See the [NUR README](https://github.com/nix-community/NUR#installation) for
overlay setup.

### Via flake input

```nix
{
  inputs.pipekit-cli.url = "github:pipekit/nur-pipekit";

  outputs = { self, nixpkgs, pipekit-cli, ... }: {
    # NixOS
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
nix profile install github:pipekit/nur-pipekit
# or
nix run github:pipekit/nur-pipekit -- --help
```

## Releases

Every tagged release of [pipekit/cli](https://github.com/pipekit/cli) pushes an
updated `pkgs/pipekit/default.nix` to this repo via goreleaser's `nix`
publisher. NUR's CI then re-evaluates and serves the new version through the
overlay.
