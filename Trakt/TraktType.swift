import Moya

public protocol TraktType: TargetType, Hashable {}

public extension TraktType {

  public var baseURL: URL { return Trakt.baseURL }

  public var method: Moya.Method { return .get }

  public var parameterEncoding: ParameterEncoding { return URLEncoding.default }

  public var task: Task { return .request }

  public var sampleData: Data {
    return "".utf8Encoded
  }

  public var hashValue: Int {
    let typeName = String(reflecting: self)

    var hash = typeName.hashValue ^ path.hashValue ^ method.hashValue

    parameters?.forEach { (key, _) in
      hash ^= key.hashValue
    }

    return hash
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

func stubbedResponse(_ filename: String) -> Data {
  let resourcesPath = Bundle(for: Trakt.self).bundlePath

	let bundle = findBundleUsing(resourcesPath: resourcesPath)

  let url = bundle.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
      return Data()
  }

  return data
}

private func findBundleUsing(resourcesPath: String) -> Bundle {
	var path = "/../"

	var bundle: Bundle? = nil
	var attempt = 0

	repeat {
		bundle = Bundle(path: resourcesPath.appending("\(path)TraktTestsResources.bundle"))
		path.append("../")
		attempt += 1
	} while bundle == nil && attempt < 5

	return bundle!
}
