class ClaudeUsageBar < Formula
  desc "Native macOS menu bar app for local Claude usage monitoring"
  homepage "https://github.com/sohryuu101/claude-usage-bar"
  url "https://github.com/sohryuu101/claude-usage-bar/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c8265e072d88b1940ce6222a192feb70f7ea16e2ad917a1a3f6f7d32b013b0c4"

  depends_on macos: :sonoma
  depends_on "zstd"

  def install
    unless which("swift")
      odie "Swift compiler is required. Install Xcode Command Line Tools with: xcode-select --install"
    end

    system "swift", "build", "-c", "release", "--disable-sandbox", "--arch", Hardware::CPU.arch.to_s

    executable = buildpath/".build/#{Hardware::CPU.arch}-apple-macosx/release/ClaudeUsageBar"
    bundle = buildpath/".build/#{Hardware::CPU.arch}-apple-macosx/release/ClaudeUsageBar_ClaudeUsageBar.bundle"
    app = prefix/"Claude Usage Bar.app"

    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp executable, app/"Contents/MacOS/ClaudeUsageBar"
    cp_r bundle, app/"Contents/Resources/ClaudeUsageBar_ClaudeUsageBar.bundle"

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
        <string>#{version}</string>
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
      case "$1" in
        stop)
          killall ClaudeUsageBar 2>/dev/null || true
          ;;
        restart)
          killall ClaudeUsageBar 2>/dev/null || true
          sleep 1
          open "#{app}"
          ;;
        start|*)
          open "#{app}"
          ;;
      esac
    SH
    chmod 0755, bin/"claude-usage-bar"

    cli_executable = buildpath/".build/#{Hardware::CPU.arch}-apple-macosx/release/claude-usage"
    bin.install cli_executable
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
