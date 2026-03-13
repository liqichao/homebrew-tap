class WhisperApple < Formula
  desc "Local speech-to-text CLI using Apple SpeechAnalyzer (macOS 26+)"
  homepage "https://github.com/liqichao/Whisper"
  url "https://github.com/liqichao/Whisper/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cbb866af58c7f5253ffe6798cf7562fd744efb78132055fb4de6b6c78e089224"
  license "MIT"

  depends_on macos: :tahoe

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"

    bin.install ".build/release/whisper" => "whisper-apple"

    # Copy bundled xcframework dylibs to libexec
    frameworks = %w[sndfile mpc ogg wavpack lame mpg123 opus FLAC vorbis tta-cpp]
    frameworks.each do |fw|
      fw_path = ".build/release/#{fw}.framework"
      next unless File.directory?(fw_path)
      (libexec/"#{fw}.framework").mkpath
      cp_r Dir["#{fw_path}/*"], libexec/"#{fw}.framework"
    end

    # Add rpath so binary finds frameworks in libexec
    system "install_name_tool", "-add_rpath", libexec.to_s, bin/"whisper-apple"
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/whisper-apple --help 2>&1", 0)
  end
end
