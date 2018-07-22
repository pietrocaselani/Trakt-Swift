extension Bundle {
  static var testing: Bundle {
    let bundle = Bundle(identifier: "io.github.pietrocaselani.TraktTests")!

    let path = bundle.bundlePath.appending("/../TraktTestsResources.bundle")
    let testingBundle = Bundle(path: path)

    return testingBundle!
  }
}
