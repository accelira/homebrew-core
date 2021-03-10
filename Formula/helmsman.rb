class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.5",
      revision: "232293302b255981cbea7d127942e1dbc36d79ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "dac90517617b5d9f6d9b80b783f5e089a96e8cd89254c994b5615b57874fa69f"
    sha256 cellar: :any_skip_relocation, catalina: "b75b6387c3b3f853252aee65583262d5c5a63b36a6a5d5e0ee5eb51b11c204f0"
    sha256 cellar: :any_skip_relocation, mojave:   "afd929bf50f142dddc7af348d611848cdb2f9be24f437bc9981b0e2ca229e6ab"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
