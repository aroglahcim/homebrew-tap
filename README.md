# homebrew-tap

Homebrew tap for [brew-updater](https://github.com/aroglahcim/brew-updater).

## Install

```sh
brew tap aroglahcim/tap
brew install aroglahcim/tap/brew-updater
```

## How the formula is published

`brew-updater` publishes a release, then dispatches it here. A workflow downloads
the release archive, computes its `sha256`, rewrites `Formula/brew-updater.rb`
and opens a pull request. Nothing is pushed to `main` directly, so a bad release
cannot reach users without a review step.

The dispatch is authorised by a fine-grained personal access token stored as
`TAP_DISPATCH_TOKEN` in the `brew-updater` repository, scoped to this repository
only.

## Recovery

The release is published before the dispatch runs, so a failed dispatch leaves a
valid tag and GitHub Release behind and only this formula behind. Replay it for
any released tag:

```sh
gh workflow run bump-formula.yml --repo aroglahcim/homebrew-tap -f tag=v1.0.0
```

The token has an expiry date. When it lapses, releases still succeed in
`brew-updater` and this formula silently stops moving, because the dispatch is
the only link between the two repositories.

## Trade-off

Once installed through the tap, `brew upgrade` updates the updater itself, so the
tool monitors its own release cycle. A broken release can silence the
notification path.

## Uninstall

```sh
brew uninstall brew-updater
brew untap aroglahcim/tap
```

The LaunchAgent installed by the formula's `post_install` is removed by
`uninstall.sh` in the `pkgshare` directory.
