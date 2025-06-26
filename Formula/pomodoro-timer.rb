class PomodoroTimer < Formula
  desc "Advanced Pomodoro Technique timer for macOS terminal with notifications and statistics"
  homepage "https://github.com/jmeiracorbal/pomodoro-timer"
  url "https://github.com/jmeiracorbal/pomodoro-timer/archive/v1.0.0.tar.gz"
  sha256 "bc0bb286b50ac6324b4c2c0d5b69fbf3878a99e2b8e2019a4062f6819b48b0e1"
  license "MIT"
  
  depends_on :macos

  def install
    bin.install "pomodoro.sh" => "pomodoro"
    
    # Create configuration directory structure for documentation
    (prefix/"share/pomodoro").mkpath
    
    # Install documentation files
    (prefix/"share/pomodoro").install "README.md"
    
    # Create man page directory and install comprehensive documentation
    man1.mkpath
    
    # Generate detailed man page
    (man1/"pomodoro.1").write <<~EOS
      .TH POMODORO 1 "#{Time.now.strftime('%B %Y')}" "pomodoro #{version}"
      .SH NAME
      pomodoro \\- Advanced Pomodoro Technique timer with notifications and statistics
      .SH SYNOPSIS
      .B pomodoro
      [\\fIOPTIONS\\fR] [\\fICOMMAND\\fR]
      .SH DESCRIPTION
      An advanced Pomodoro Technique timer for macOS terminal featuring real-time controls,
      system notifications, productivity statistics, and full customization. The Pomodoro
      Technique is a time management method that uses a timer to break work into intervals,
      traditionally 25 minutes in length, separated by short breaks.
      .PP
      This implementation provides a rich terminal interface with visual progress bars,
      interactive controls, persistent configuration, and comprehensive session tracking.
      .SH OPTIONS
      .TP
      .BR \\-h ", " \\-\\-help
      Show comprehensive help message and exit
      .TP
      .BR \\-v ", " \\-\\-version
      Show version information and exit
      .TP
      .BR \\-w ", " \\-\\-work\\-time " " \\fIMINUTES\\fR
      Set work session duration in minutes (default: 25)
      .TP
      .BR \\-s ", " \\-\\-short\\-break " " \\fIMINUTES\\fR
      Set short break duration in minutes (default: 5)
      .TP
      .BR \\-l ", " \\-\\-long\\-break " " \\fIMINUTES\\fR
      Set long break duration in minutes (default: 15)
      .TP
      .BR \\-c ", " \\-\\-cycles " " \\fINUMBER\\fR
      Set number of sessions until long break (default: 4)
      .TP
      .BR \\-\\-no\\-sound
      Disable sound notifications
      .TP
      .BR \\-\\-no\\-notifications
      Disable system notifications
      .TP
      .BR \\-\\-config
      Show current configuration settings
      .TP
      .BR \\-\\-reset\\-config
      Reset configuration to default values
      .SH COMMANDS
      .TP
      .B start
      Start a pomodoro session (default action)
      .TP
      .B stats
      Show productivity statistics and session history
      .TP
      .B reset\\-stats
      Reset all statistics and session history
      .TP
      .B config
      Interactive configuration setup
      .SH INTERACTIVE CONTROLS
      During any active session, the following keyboard controls are available:
      .TP
      .B SPACE
      Pause or resume the current timer
      .TP
      .B Q
      Quit the current session
      .TP
      .B S
      Skip to the next break or session
      .TP
      .B R
      Reset the current timer to its starting value
      .SH FILES
      .TP
      .I ~/.pomodoro/config
      User configuration file with timer settings
      .TP
      .I ~/.pomodoro/pomodoro.log
      Session history and activity log
      .TP
      .I ~/.pomodoro/stats.json
      Statistics database in JSON format
      .SH EXAMPLES
      .TP
      .B pomodoro
      Start a pomodoro session with default settings (25/5/15 minutes)
      .TP
      .B pomodoro \\-w 30 \\-s 10
      Use 30-minute work sessions with 10-minute breaks
      .TP
      .B pomodoro \\-\\-no\\-sound \\-\\-no\\-notifications
      Run in silent mode without audio or visual notifications
      .TP
      .B pomodoro stats
      View productivity statistics and recent session history
      .TP
      .B pomodoro config
      Launch interactive configuration setup
      .TP
      .B pomodoro \\-w 45 \\-c 3
      Use 45-minute sessions with long breaks every 3 cycles
      .SH THE POMODORO TECHNIQUE
      The Pomodoro Technique, developed by Francesco Cirillo, consists of:
      .PP
      1. Choose a task to work on
      .br
      2. Set the timer for 25 minutes (one "pomodoro")
      .br
      3. Work on the task until the timer expires
      .br
      4. Take a short break (5 minutes)
      .br
      5. After 4 pomodoros, take a longer break (15-30 minutes)
      .PP
      This implementation automates the timing and tracking aspects while providing
      flexibility to customize intervals according to personal preferences.
      .SH NOTIFICATIONS
      The application integrates with macOS notification system to provide:
      .PP
      • Session completion alerts
      .br
      • Break time reminders
      .br
      • Cycle completion notifications
      .br
      • Custom sound alerts
      .PP
      Notification permissions may need to be granted in System Preferences.
      .SH STATISTICS
      The tool tracks comprehensive productivity metrics including:
      .PP
      • Daily completed sessions
      .br
      • Total focus time
      .br
      • Session completion rates
      .br
      • Historical trends
      .br
      • Break adherence
      .SH EXIT STATUS
      .TP
      .B 0
      Successful completion
      .TP
      .B 1
      Error in execution or user cancellation
      .SH ENVIRONMENT
      The application respects the following macOS system settings:
      .PP
      • Notification preferences
      .br
      • Sound output settings
      .br
      • Terminal appearance and colors
      .SH NOTES
      This application is designed specifically for macOS and requires:
      .PP
      • macOS 12.0 (Monterey) or later
      .br
      • Terminal.app or compatible terminal emulator
      .br
      • Notification permissions for full functionality
      .PP
      For optimal experience, ensure the terminal has notification permissions
      enabled in System Preferences > Security & Privacy > Privacy > Notifications.
      .SH SEE ALSO
      .BR osascript (1),
      .BR afplay (1),
      .BR date (1),
      .BR sleep (1)
      .SH AUTHOR
      Written by José Manuel Meira Corbal.
      .SH REPORTING BUGS
      Report bugs and request features at:
      .br
      https://github.com/jmeiracorbal/pomodoro-timer/issues
      .SH COPYRIGHT
      Copyright © 2025 José Manuel Meira Corbal.
      .br
      This is free software; see the source for copying conditions.
    EOS
  end

  def post_install
    # Create config directory for the user
    config_dir = "#{Dir.home}/.pomodoro"
    FileUtils.mkdir_p(config_dir) unless Dir.exist?(config_dir)
    
    # Set up initial configuration if it doesn't exist
    config_file = "#{config_dir}/config"
    unless File.exist?(config_file)
      File.write(config_file, <<~CONFIG)
        # Pomodoro Timer Configuration
        WORK_TIME=25
        SHORT_BREAK=5
        LONG_BREAK=15
        SESSIONS_UNTIL_LONG=4
        SOUND_ENABLED=true
        NOTIFICATIONS_ENABLED=true
      CONFIG
    end
    
    # Initialize stats file
    stats_file = "#{config_dir}/stats.json"
    unless File.exist?(stats_file)
      File.write(stats_file, '{"daily_sessions": {}, "total_sessions": 0, "total_focus_time": 0}')
    end
  end

  def caveats
    <<~EOS
      🍅 Pomodoro Timer is ready to boost your productivity!
      
      Quick Start:
        pomodoro                    # Start with default settings
        pomodoro config             # Configure your preferences
        pomodoro stats              # View your productivity stats
      
      Configuration and logs are stored in: ~/.pomodoro/
      
      For notifications to work properly, ensure Terminal has
      notification permissions in System Preferences > Security & Privacy.
      
      Pro Tips:
        • Use 'pomodoro -w 30 -s 10' for longer sessions
        • Add '--no-sound' for quiet environments
        • Check 'pomodoro stats' to track your progress
      
      Happy focusing! 🎯
    EOS
  end

  test do
    # Test that the script exists and is executable
    assert_predicate bin/"pomodoro", :exist?
    assert_predicate bin/"pomodoro", :executable?
    
    # Test help output contains expected content
    help_output = shell_output("#{bin}/pomodoro --help")
    assert_match "Pomodoro Timer v#{version}", help_output
    assert_match "DESCRIPTION:", help_output
    assert_match "Pomodoro Technique", help_output
    assert_match "OPTIONS:", help_output
    assert_match "COMMANDS:", help_output
    assert_match "EXAMPLES:", help_output
    
    # Test version output
    version_output = shell_output("#{bin}/pomodoro --version")
    assert_match "Pomodoro Timer v#{version}", version_output
    assert_match "productivity tool", version_output
    
    # Test configuration display
    config_output = shell_output("#{bin}/pomodoro --config")
    assert_match "Current Configuration", config_output
    assert_match "Work Time:", config_output
    assert_match "Short Break:", config_output
    assert_match "Long Break:", config_output
    
    # Test statistics command (should handle empty stats gracefully)
    stats_output = shell_output("#{bin}/pomodoro stats 2>&1")
    assert_match "Productivity Statistics", stats_output
    
    # Test that dry-run equivalent operations work safely
    # Since we can't easily test full timer functionality, we test argument parsing
    system bin/"pomodoro", "--help"
    assert_equal 0, $CHILD_STATUS.exitstatus
    
    system bin/"pomodoro", "--version"
    assert_equal 0, $CHILD_STATUS.exitstatus
    
    system bin/"pomodoro", "--config"
    assert_equal 0, $CHILD_STATUS.exitstatus
    
    # Verify man page was installed and is readable
    assert_predicate man1/"pomodoro.1", :exist?
    man_content = File.read(man1/"pomodoro.1")
    assert_match "Pomodoro Technique timer", man_content
    assert_match "INTERACTIVE CONTROLS", man_content
    
    # Test configuration directory creation
    config_dir = "#{Dir.home}/.pomodoro"
    # Don't assert existence since it may interfere with user's actual config
    # Just ensure the install process doesn't fail
    
    # Test invalid arguments are handled gracefully
    result = shell_output("#{bin}/pomodoro --invalid-option 2>&1", 1)
    assert_match "Unknown option", result
    
    puts "✅ All tests passed! Pomodoro Timer is ready to use."
  end
end
