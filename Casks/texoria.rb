# Template rendered by scripts/render-manifests.sh and pushed to Herbrant/homebrew-tap as
# Casks/texoria.rb by the release workflow.
cask "texoria" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.1"
  sha256 arm:   "6b0e8b5cd5e6877687b7982ae176430301a8b74b7260ae94a8dfb867f6d9757c",
         intel: "5440e9b522bb31d968e40fbe255e84fed6ca6936c74f17cbbb8f7a8d91361daa"

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
