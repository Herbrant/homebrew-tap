# Template rendered by scripts/render-manifests.sh and pushed to Herbrant/homebrew-tap as
# Casks/texoria.rb by the release workflow.
cask "texoria" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.0"
  sha256 arm:   "bde36fcb6f73c21ccd1fc9036cf36389b9aa9d7429335567cdca1e0c8a907623",
         intel: "4cc46c07e235fb1a2442aec903cff36020a458901843371d8841565e33c28d50"

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
