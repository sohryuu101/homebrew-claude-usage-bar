class ClaudeUsageBar < Formula
  desc "Native macOS menu bar app for local Claude usage monitoring"
  homepage "https://github.com/YOUR_GITHUB_USER/claude-usage-bar"
  url "https://github.com/YOUR_GITHUB_USER/claude-usage-bar/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_SHA256"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox", "--arch", Hardware::CPU.arch.to_s

    executable = buildpath/".build/#{Hardware::CPU.arch}-apple-macosx/release/ClaudeUsageBar"
    app = prefix/"Claude Usage Bar.app"

    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp executable, app/"Contents/MacOS/ClaudeUsageBar"

    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleName</key>
        <string>Claude Usage Bar</string>
        <key>CFBundleDisplayName</key>
        <string>Claude Usage Bar</string>
        <key>CFBundleIdentifier</key>
        <string>dev.local.claude-usage-bar</string>
        <key>CFBundleExecutable</key>
        <string>ClaudeUsageBar</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>0.1.0</string>
        <key>CFBundleVersion</key>
        <string>1</string>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
        <key>LSUIElement</key>
        <true/>
      </dict>
      </plist>
    PLIST

    system "codesign", "--force", "--deep", "--sign", "-", app

    (bin/"claude-usage-bar").write <<~SH
      #!/bin/bash
      open "#{app}"
    SH
    chmod 0755, bin/"claude-usage-bar"
  end

  def caveats
    <<~EOS
      Start Claude Usage Bar with:
        claude-usage-bar

      Or open the app bundle directly:
        open "#{prefix}/Claude Usage Bar.app"

      This is built and ad-hoc signed locally by Homebrew. No Apple Developer ID is required.
    EOS
  end

  test do
    assert_path_exists prefix/"Claude Usage Bar.app/Contents/MacOS/ClaudeUsageBar"
    assert_path_exists bin/"claude-usage-bar"
  end
end
