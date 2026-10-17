# Template rendered by scripts/render-manifests.sh and pushed to Herbrant/homebrew-tap as
# Casks/texoria.rb by the release workflow.
cask "texoria" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.3.0"
  sha256 arm:   "54a85c32fd82e13a9f21a0c8cc4d1cf343d4250ce592b3be7840a1123b3ab0ed",
         intel: "86f77cd4163f2930340d20e14673b4a1a8fa5b60e6683f106fbc24698254df85"

  url "https://github.com/Herbrant/TeXoria/releases/download/v#{version}/texoria-#{version}-macos-#{arch}.dmg"
  name "TeXoria"
  desc "Elegant, fast LaTeX editor"
  homepage "https://github.com/Herbrant/TeXoria"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "TeXoria.app"

  # The app is signed ad hoc, not notarized: without this Gatekeeper refuses to open it.
  postflight_steps do
    if_path_exists "{{appdir}}/TeXoria.app" do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{appdir}}/TeXoria.app"]
    end
  end

  uninstall quit: "app.texoria.TeXoria"

  zap trash: [
    "~/Library/Application Support/app.TeXoria.TeXoria",
    "~/Library/Preferences/app.texoria.TeXoria.plist",
    "~/Library/Saved Application State/app.texoria.TeXoria.savedState",
  ]

  caveats <<~EOS
    TeXoria is not notarized by Apple, so this cask removes the quarantine attribute
    from #{appdir}/TeXoria.app after installing it.
  EOS
end
