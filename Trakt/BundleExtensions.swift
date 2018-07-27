extension Bundle {
  static var testing: Bundle {
    let bundle = Bundle(for: Trakt.self)

    let path = bundle.bundlePath.appending("/../../../../TraktTestsResources.bundle")
    let testingBundle = Bundle(path: path)

    return testingBundle!
  }
}
