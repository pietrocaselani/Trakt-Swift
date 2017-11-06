import Moya

public enum Movies {
  case trending(page: Int, limit: Int, extended: Extended)
  case summary(movieId: String, extended: Extended)
}

extension Movies: TraktType {
  public var path: String {
    switch self {
    case .trending:
      return "movies/trending"
    case .summary(let movieId, _):
      return "movies/\(movieId)"
    }
  }

  public var task: Task {
    let params: [String: Any]
    switch self {
    case .trending(let page, let limit, let extended):
      params = ["page": page, "limit": limit, "extended": extended.rawValue]
    case .summary(_, let extended):
      params = ["extended": extended.rawValue]
    }

    return .requestParameters(parameters: params, encoding: URLEncoding.default)
  }

  public var sampleData: Data {
    switch self {
    case .trending:
      return stubbedResponse("trakt_movies_trending")
    case .summary:
      return stubbedResponse("trakt_movies_summary")
    }
  }

}
