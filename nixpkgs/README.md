# nixpkgs source

Hand-maintained source for the Pipekit CLI derivation that lives upstream at
`pkgs/by-name/pi/pipekit/package.nix` in
[NixOS/nixpkgs](https://github.com/NixOS/nixpkgs).

This is a separate file from `../pkgs/pipekit/default.nix`, which is the
auto-generated derivation that goreleaser writes on every CLI release for the
NUR / flake-input distribution path. The two derivations target different
consumers:

* `nixpkgs/package.nix` is what ships in nixpkgs — multi-arch `fetchurl`,
  `passthru.updateScript`, hand-maintained.
* `pkgs/pipekit/default.nix` is what goreleaser pushes here every release —
  single-arch, generated, used by NUR and direct flake consumers.

## First PR (manual)

1. Fork `NixOS/nixpkgs` to your GitHub account.
2. Add yourself to `maintainers/maintainer-list.nix` if you are not already
   listed, and reference yourself in `meta.maintainers` in `package.nix`.
3. Copy `package.nix` to `pkgs/by-name/pi/pipekit/package.nix` in your fork.
4. Set `version` to the current CLI release (without the `v` prefix).
5. Replace each `lib.fakeHash` with the real SRI hash. Either let Nix fail and
   report the hash:
   ```sh
   nix-build -A pipekit --argstr system x86_64-linux
   ```
   or precompute with `nix-prefetch-url --type sha256` for each platform tarball.
6. Verify the build on every platform you can (`nix build .#pipekit` with the
   relevant `system`); run `nixpkgs-review pr <N>` against a draft PR.
7. Open the PR per the [nixpkgs contributing
   guide](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md).

## Subsequent bumps (CI-driven)

Once the package is in nixpkgs, each CLI release pushes a version bump PR
against `NixOS/nixpkgs`. The CI step lives in the (closed-source) release
pipeline, runs after `release-pipekit-cli` completes, and:

1. Clones `pipekit/nixpkgs` (the org's fork) and fetches `upstream/master`.
2. Cuts a branch `pipekit-bump-${VERSION}`.
3. Runs `nix-update --version=${VERSION} pipekit`, which rewrites `version`
   and refetches per-platform hashes.
4. Commits, pushes, opens a PR against `NixOS/nixpkgs:master` with `gh pr
   create`.

The PAT used for that step needs `repo` scope on `pipekit/nixpkgs` and the
ability to open cross-repo PRs against `NixOS/nixpkgs`.

## Coordinated changes

If the goreleaser archive layout in `pipekit/cli`'s release pipeline ever
changes (URL pattern, archive name template, platform set), the `package.nix`
here needs to change in lockstep — it encodes the URL template in `src.url`
and the platform list in `sources`. Update both, then open the nixpkgs PR
against the next release.
