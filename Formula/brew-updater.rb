class BrewUpdater < Formula
  desc "Daily Homebrew update check with a clickable macOS notification"
  homepage "https://github.com/aroglahcim/brew-updater"
  url "https://github.com/aroglahcim/brew-updater/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "83f37d2540afbebafbecd8e07d620eb116af52a820e5e158f111210605b1ca70"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos
  depends_on "terminal-notifier"

  def install
    bin.install "bin/brew-update-check", "bin/brew-update-run"
    pkgshare.install "launchd", "install.sh", "uninstall.sh"
  end

  # Homebrew runs post-install inside a sandbox that denies mach-lookup for
  # launchd and denies every write outside the allowlist, so the LaunchAgent
  # cannot be registered here. The attempt is kept as a best-effort: a run
  # outside the sandbox (a source install) still configures the agent, and a
  # sandboxed pour only prints the steps that remain.
  post_install_steps do
    run "{{pkgshare}}/install.sh",
        args:         ["--bin-dir", "{{opt_prefix}}/bin"],
        must_succeed: false
  end

  def caveats
    <<~EOS
      brew-updater needs one command to run outside Homebrew's sandbox,
      because post-install cannot write the LaunchAgent or call launchctl:

        #{opt_pkgshare}/install.sh --bin-dir #{opt_bin}

      That renders ~/Library/LaunchAgents/com.aroglahcim.brew-updater.plist and
      loads it. Then check notification permissions for terminal-notifier:

        terminal-notifier -diagnose
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/brew-update-check --help")
  end
end
