# frozen_string_literal: true

require_relative "../lib/registry_download"

class Act3Pt < Formula
  desc "ACT3 Project Tool - ACT3's project generator, updater, and automator"
  homepage "https://git.act3-ace.com/devsecops/act3-pt"
  version "1.54.5"

  depends_on "glab"
  depends_on "typst"

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_macos do
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/ace/homebrew-ace-tools/formula/act3-pt@sha256:c1145bc21759cb76b092bfc07cea1ec248ba5c6d4eb3ce34b6be050fc8e70508",
          using: BlobDownloadStrategy
      sha256 "c1145bc21759cb76b092bfc07cea1ec248ba5c6d4eb3ce34b6be050fc8e70508"
    end
    if Hardware::CPU.arm?
      url "reg.git.act3-ace.com/ace/homebrew-ace-tools/formula/act3-pt@sha256:ddda0561fa67b7f20bb63c92be158e4e8b998aa6090db13573bbb50cf3b7fb8b",
          using: BlobDownloadStrategy
      sha256 "ddda0561fa67b7f20bb63c92be158e4e8b998aa6090db13573bbb50cf3b7fb8b"
    end
  end

  # Generated by https://git.act3-ace.com/ace/homebrew-ace-tools/-/blob/master/bin/formulize.sh
  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "reg.git.act3-ace.com/ace/homebrew-ace-tools/formula/act3-pt@sha256:9047ba8af839fd6f2fa69b24b388aeb1dd5ef689255991a3c8c381eef8ae94e6",
          using: BlobDownloadStrategy
      sha256 "9047ba8af839fd6f2fa69b24b388aeb1dd5ef689255991a3c8c381eef8ae94e6"
    end
    if Hardware::CPU.intel?
      url "reg.git.act3-ace.com/ace/homebrew-ace-tools/formula/act3-pt@sha256:dbca38e427af17ddd4dfa7c1cc7f42f254f8ecf7ff78c51af363cb7f963c5223",
          using: BlobDownloadStrategy
      sha256 "dbca38e427af17ddd4dfa7c1cc7f42f254f8ecf7ff78c51af363cb7f963c5223"
    end
  end

  conflicts_with "act3-pt-beta", because: "act3-pt and act3-pt-beta install conflicting executables"

  def install
    bin.install "act3-pt"
    generate_completions_from_executable(bin/"act3-pt", "completion")

    # Generate manpages
    mkdir "man" do
      system bin/"act3-pt", "gendocs", "man", "."
      man1.install Dir["*.1"]
      man5.install Dir["*.5"]
    end

    # Generate JSON Schema definitions
    # Use pkgetc here so path doesn't change over version numbers
    # Cannot use symlink for this because VS Code cannot follow symlinks for schema files
    mkdir pkgetc do
      system bin/"act3-pt", "genschema", "."
    end
  end

  def caveats
    <<~EOS
      Add the following to VS Code's settings.json file to enable YAML file validation:
        "yaml.schemas": {
          "file://#{pkgetc}/pt.act3-ace.io.schema.json": [
            "act3-pt-config.yaml",
            "act3/pt/config.yaml",
            ".act3-pt.yaml",
            ".act3-template.yaml"
          ]
        }

      Check out the quick start guide to get started with act3-pt:
        act3-pt info quick-start-guide
    EOS
  end

  test do
    system "#{bin}/act3-pt", "version"
  end
end
