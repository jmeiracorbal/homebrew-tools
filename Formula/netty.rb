class Netty < Formula
  desc "Comprehensive network utilities toolkit for macOS"
  homepage "https://github.com/jmeiracorbal/netty"
  url "https://github.com/jmeiracorbal/netty/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7e2ad93c7eec4301352cddbd0c99e4d983a2096794b3ea782dd17ef7c166cc70"
  license "MIT"

  depends_on :macos

  def install
    bin.install "netty.sh" => "netty"
  end

  def post_install
    config_dir = "#{Dir.home}/.netty"
    mkdir_p(config_dir)
    mkdir_p("#{config_dir}/results")

    log_file = "#{config_dir}/netty.log"
    return if File.exist?(log_file)

    File.write(log_file, "# Netty Network Utilities Log\n# Started: #{Time.now}\n")
  end

  def caveats
    <<~EOS
      🌐 Netty is ready for network diagnostics!

      Quick Start:
        netty wifi                  # WiFi networks and connection info
        netty speed                 # Internet speed test
        netty dns flush             # Clear DNS cache
        netty ping google.com       # Enhanced ping test
        netty monitor               # Real-time traffic monitoring

      Configuration stored in: ~/.netty/

      Pro Tips:
        • Use 'netty ip' for geolocation info
        • Try 'netty export json' to save reports
        • Run 'netty monitor' for real-time network analysis
        • Use '--quiet' flag in scripts

      Happy networking! 🚀
    EOS
  end

  test do
    assert_path_exists bin/"netty"
    assert_predicate bin/"netty", :executable?

    help_output = shell_output("#{bin}/netty --help")
    assert_match "Netty v#{version}", help_output
    assert_match "DESCRIPTION:", help_output

    version_output = shell_output("#{bin}/netty --version")
    assert_match "Netty v#{version}", version_output

    system bin/"netty", "--help"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
