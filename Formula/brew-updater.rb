class BrewUpdater < Formula
  desc "Daily Homebrew update check with a clickable macOS notification"
  homepage "https://github.com/aroglahcim/brew-updater"
  url "https://github.com/aroglahcim/brew-updater/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a08f5281db122f3ee0b9ccd8ec9a13dfbba867a94c0b6f6344b89036a0959a8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "terminal-notifier"
  depends_on :macos

  def install
    bin.install "bin/brew-update-check", "bin/brew-update-run"
    pkgshare.install "launchd", "install.sh", "uninstall.sh"
  end

  def post_install
    system pkgshare/"install.sh", "--bin-dir", bin, "--from-prefix"
  end

  def caveats
    <<~EOS
      The LaunchAgent was installed for the current user.
      Check notification permissions for terminal-notifier and run:
        terminal-notifier -diagnose
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/brew-update-check --help")
  end
end
