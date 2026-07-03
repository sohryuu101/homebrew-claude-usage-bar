# Homebrew Tap: Claude Usage Bar

Homebrew tap for Claude Usage Bar.

## Publish Flow

1. Push the app repo to GitHub, for example:

   ```bash
   cd /Users/feb/ZCodeProject/claude-usage-bar
   git remote add origin git@github.com:YOUR_GITHUB_USER/claude-usage-bar.git
   git push -u origin main
   git tag v0.1.0
   git push origin v0.1.0
   ```

2. Get the tarball SHA:

   ```bash
   curl -L https://github.com/YOUR_GITHUB_USER/claude-usage-bar/archive/refs/tags/v0.1.0.tar.gz | shasum -a 256
   ```

3. Edit `Formula/claude-usage-bar.rb`:

   - Replace `YOUR_GITHUB_USER`.
   - Replace `REPLACE_WITH_SHA256`.

4. Push this tap repo to GitHub as `homebrew-claude-usage-bar`.

Users install with:

```bash
brew tap YOUR_GITHUB_USER/claude-usage-bar
brew install claude-usage-bar
claude-usage-bar
```

The formula builds from source on the user's Mac and ad-hoc signs the local `.app`, so a paid Apple Developer ID certificate is not required.
