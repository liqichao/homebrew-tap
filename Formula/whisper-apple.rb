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
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/whisper-apple --help 2>&1", 0)
  end
end
