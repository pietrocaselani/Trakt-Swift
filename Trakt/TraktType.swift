import Moya

public protocol TraktType: TargetType, AccessTokenAuthorizable, Hashable {}

public extension TraktType {

  public var baseURL: URL { return Trakt.baseURL }

  public var method: Moya.Method { return .get }

  public var headers: [String: String]? { return nil }

  public var task: Task { return .requestPlain }

  public var authorizationType: AuthorizationType { return .none }

  public var sampleData: Data {
    return "".utf8Encoded
  }

  public var hashValue: Int {
    let typeName = String(reflecting: self)

    return typeName.hashValue ^ path.hashValue ^ method.hashValue ^ authorizationType.value.hashValue
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

func stubbedResponse(_ filename: String) -> Data {
  let bundle = Bundle.testing

  let url = bundle.url(forResource: filename, withExtension: "json")

  guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
      return Data()
  }

  return data
}
