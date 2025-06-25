class CloudStorageSymlinks < Formula
  desc "Automatically create symbolic links to macOS Cloud Storage folders"
  homepage "https://github.com/jmeiracorbal/cloud-storage-symlinks"
  url "https://github.com/jmeiracorbal/cloud-storage-symlinks/archive/v1.0.0.tar.gz"
  sha256 "336c2c38afb6a3855712dc793119f934024c215a2e3789abd9718263e7884ae4"
  license "MIT"
  
  depends_on :macos

  def install
    bin.install "setup_cloud_storage.sh" => "cloud-storage-symlinks"
  end

  test do
    system "#{bin}/cloud-storage-symlinks", "--help"
  end
end
