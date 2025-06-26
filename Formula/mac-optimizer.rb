class MacOptimizer < Formula
  desc "Comprehensive macOS optimization and cleanup tool"
  homepage "https://github.com/jmeiracorbal/mac-optimizer"
  url "https://github.com/jmeiracorbal/mac-optimizer/archive/v1.0.0.tar.gz"
  sha256 "76ba3bef441e71dc4cf68fc6e52c947782a00d2ffef5213ea7af4256e57021b5"
  license "MIT"
  
  depends_on :macos

  def install
    bin.install "mac-optimizer.sh" => "mac-optimizer"
    
    # Create man page directory and install documentation
    man1.mkpath
    
    # Generate a comprehensive man page
    (man1/"mac-optimizer.1").write <<~EOS
      .TH MAC-OPTIMIZER 1 "#{Time.now.strftime('%B %Y')}" "mac-optimizer #{version}"
      .SH NAME
      mac-optimizer \\- comprehensive macOS optimization and cleanup tool
      .SH SYNOPSIS
      .B mac-optimizer
      [\\fIOPTIONS\\fR] [\\fIMODULES\\fR]
      .SH DESCRIPTION
      Mac Optimizer improves system performance through intelligent cache management,
      service optimization, and resource cleanup. It safely cleans temporary files,
      optimizes system services, and frees up disk space and memory.
      .PP
      The tool operates on multiple modules that can be run individually or together.
      All destructive operations require user confirmation unless run with --force.
      .SH OPTIONS
      .TP
      .BR \\-h ", " \\-\\-help
      Show help message and exit
      .TP
      .BR \\-v ", " \\-\\-version
      Show version information and exit
      .TP
      .BR \\-d ", " \\-\\-dry\\-run
      Preview changes without executing them
      .TP
      .BR \\-q ", " \\-\\-quiet
      Run in silent mode with minimal output
      .TP
      .BR \\-f ", " \\-\\-force
      Skip confirmation prompts
      .TP
      .BR \\-\\-log\\-file " " \\fIFILE\\fR
      Specify custom log file location (default: ~/.mac-optimizer.log)
      .SH MODULES
      .TP
      .B cache
      Clean system and application caches
      .TP
      .B spotlight
      Optimize and reindex Spotlight search (requires admin permissions)
      .TP
      .B permissions
      Repair system permissions and directory access rights
      .TP
      .B services
      Restart problematic system services (Finder, Dock, etc.)
      .TP
      .B memory
      Free memory and reduce memory pressure
      .TP
      .B logs
      Clean old system and application logs
      .TP
      .B browsers
      Clean browser caches and temporary data (requires confirmation)
      .TP
      .B downloads
      Clean old files from Downloads folder (requires confirmation)
      .TP
      .B all
      Run all optimization modules (default)
      .SH EXAMPLES
      .TP
      .B mac-optimizer
      Run complete interactive optimization
      .TP
      .B mac-optimizer --dry-run
      Preview all changes without executing
      .TP
      .B mac-optimizer cache memory
      Only clean caches and free memory
      .TP
      .B mac-optimizer --force --quiet
      Run complete optimization without prompts
      .TP
      .B mac-optimizer browsers downloads
      Clean only browser data and old downloads
      .SH FILES
      .TP
      .I ~/.mac-optimizer.log
      Default log file location
      .TP
      .I ~/Library/Caches/
      Primary user cache directory cleaned by the tool
      .TP
      .I /Library/Caches/
      System cache directory (requires admin permissions)
      .SH SAFETY
      The tool includes multiple safety mechanisms:
      .PP
      • Dry-run mode for previewing changes
      .br
      • User confirmations for destructive operations
      .br
      • Automatic backups of critical files
      .br
      • Detailed logging of all operations
      .br
      • Non-destructive cleaning that preserves directory structures
      .SH EXIT STATUS
      .TP
      .B 0
      Successful completion
      .TP
      .B 1
      General error or user cancellation
      .SH NOTES
      Some operations require administrator permissions and may prompt for password.
      Spotlight optimization can take significant time and continues in the background.
      Browser cleanup may require re-logging into websites.
      .SH SEE ALSO
      .BR purge (8),
      .BR dscacheutil (1),
      .BR mdutil (1),
      .BR diskutil (8)
      .SH AUTHOR
      Written by José Manuel Meira Corbal.
      .SH REPORTING BUGS
      Report bugs at: https://github.com/jmeiracorbal/mac-optimizer/issues
    EOS
  end

  def caveats
    <<~EOS
      Some optimizations require administrator permissions.
      
      For regular maintenance, consider running:
        mac-optimizer cache memory
      
      For complete optimization:
        mac-optimizer
      
      View the log file at: ~/.mac-optimizer.log
    EOS
  end

  test do
    # Test that the script exists and is executable
    assert_predicate bin/"mac-optimizer", :exist?
    assert_predicate bin/"mac-optimizer", :executable?
    
    # Test help output
    help_output = shell_output("#{bin}/mac-optimizer --help")
    assert_match "Mac Optimizer v#{version}", help_output
    assert_match "DESCRIPTION:", help_output
    assert_match "OPTIONS:", help_output
    
    # Test version output
    version_output = shell_output("#{bin}/mac-optimizer --version")
    assert_match "Mac Optimizer v#{version}", version_output
    
    # Test dry-run mode (safe to test)
    dry_run_output = shell_output("#{bin}/mac-optimizer --dry-run cache 2>&1")
    assert_match "DRY-RUN MODE", dry_run_output
    
    # Verify man page was installed
    assert_predicate man1/"mac-optimizer.1", :exist?
  end
end
