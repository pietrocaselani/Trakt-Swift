import Moya

public enum Seasons {
  case summary(showId: String, exteded: Extended)
}

extension Seasons: TraktType {
  public var path: String {
    switch self {
    case .summary(let showId):
      return "/shows/\(showId)/seasons"
    }
  }

  public var task: Task {
    switch self {
    case .summary(_, let exteded):
      return .requestParameters(parameters: ["extended": exteded.rawValue], encoding: URLEncoding.default)
    }
  }

  public var authorizationType: AuthorizationType {
    return .none
  }

  public var sampleData: Data {
    switch self {
    case .summary:
      return stubbedResponse("trakt_seasons_summary")
    }
  }
}
