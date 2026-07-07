# Homebrew Tap: Claude Usage Bar

Homebrew tap for Claude Usage Bar.

## Install

```bash
brew tap sohryuu101/claude-usage-bar
brew install claude-usage-bar
claude-usage-bar
```

When a bottle is available for the user's macOS/CPU combination, Homebrew
downloads the prebuilt package. Otherwise, the formula still builds from source
and ad-hoc signs the local app bundle.

## Publish Flow

### 1. Tag the app release

Push and tag the app repo:

```bash
cd /Users/feb/ZCodeProject/claude-usage-bar
git push origin main
git tag v0.4.0
git push origin v0.4.0
```

### 2. Update the formula source URL and SHA

Get the source tarball SHA:

```bash
curl -L https://github.com/sohryuu101/claude-usage-bar/archive/refs/tags/v0.4.0.tar.gz | shasum -a 256
```

Edit `Formula/claude-usage-bar.rb`:

- Update the `url` tag.
- Update the source `sha256`.
- Remove any old `bottle do` block until the new bottle is built.

Commit and push the formula update:

```bash
cd /Users/feb/ZCodeProject/homebrew-claude-usage-bar
git add Formula/claude-usage-bar.rb
git commit -m "Update claude-usage-bar to 0.4.0"
git push origin main
```

### 3. Build and publish a Homebrew bottle

In GitHub Actions for this tap repo, run **Build Homebrew Bottle** manually:

- `release_tag`: the same release tag, for example `v0.4.0`
- `formula`: `claude-usage-bar`

The workflow:

- Runs `brew test-bot` on macOS.
- Builds bottles on `macos-14` arm64 and `macos-15-intel`.
- Creates the GitHub Release if it does not exist.
- Uploads the `.bottle.tar.gz` and `.bottle.json` assets to the release.
- Merges the bottle JSON files and commits the generated `bottle do` block back
  to this tap by default.
- Uploads a `bottle-block.patch` artifact for review or manual recovery.

### 4. Verify the bottle block

After the workflow finishes, pull the tap repo and verify the formula contains
a `bottle do` block:

```bash
cd /Users/feb/ZCodeProject/homebrew-claude-usage-bar
git pull origin main
brew audit --strict --online claude-usage-bar
brew test claude-usage-bar
```

If the workflow was run with `commit_bottle_block` disabled, download the
workflow artifact named `bottle-block-v0.4.0`, apply `bottle-block.patch`, then
commit and push the formula change manually.

After the bottle block is pushed, users on the matching platform get the bottle
with:

```bash
brew update
brew reinstall claude-usage-bar
```

## Notes

- No paid Apple Developer ID certificate is required.
- The app bundle is ad-hoc signed during the formula install/build process.
- Bottles avoid requiring Xcode or a local Swift build on matching platforms.
- Source builds remain available as a fallback for platforms without a bottle.
