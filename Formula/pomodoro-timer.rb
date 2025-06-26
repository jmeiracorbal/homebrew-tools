class PomodoroTimer < Formula
  desc "Pomodoro Technique timer for macOS terminal with notifications"
  homepage "https://github.com/jmeiracorbal/pomodoro-timer"
  url "https://github.com/jmeiracorbal/pomodoro-timer/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bc0bb286b50ac6324b4c2c0d5b69fbf3878a99e2b8e2019a4062f6819b48b0e1"
  license "MIT"

  depends_on :macos

  def install
    bin.install "pomodoro.sh" => "pomodoro"
  end

  def post_install
    config_dir = "#{Dir.home}/.pomodoro"
    mkdir_p(config_dir)

    config_file = "#{config_dir}/config"
    return if File.exist?(config_file)

    File.write(config_file, <<~CONFIG)
      # Pomodoro Timer Configuration
      WORK_TIME=25
      SHORT_BREAK=5
      LONG_BREAK=15
      SESSIONS_UNTIL_LONG=4
      SOUND_ENABLED=true
      NOTIFICATIONS_ENABLED=true
    CONFIG

    stats_file = "#{config_dir}/stats.json"
    File.write(stats_file, '{"daily_sessions": {}, "total_sessions": 0, "total_focus_time": 0}')
  end

  def caveats
    <<~EOS
      🍅 Pomodoro Timer is ready to boost your productivity!

      Quick Start:
        pomodoro                    # Start with default settings
        pomodoro config             # Configure your preferences
        pomodoro stats              # View your productivity stats

      Configuration stored in: ~/.pomodoro/

      Pro Tips:
        • Use 'pomodoro -w 30 -s 10' for longer sessions
        • Add '--no-sound' for quiet environments
        • Check 'pomodoro stats' to track your progress

      Happy focusing! 🎯
    EOS
  end

  test do
    assert_path_exists bin/"pomodoro"
    assert_predicate bin/"pomodoro", :executable?

    help_output = shell_output("#{bin}/pomodoro --help")
    assert_match "Pomodoro Timer", help_output

    version_output = shell_output("#{bin}/pomodoro --version")
    assert_match "Pomodoro Timer", version_output

    system bin/"pomodoro", "--help"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
