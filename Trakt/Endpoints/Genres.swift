import Moya

public enum Genres {
  case list(GenreType)
}

extension Genres: TraktType {

  public var path: String {
    switch self {
    case .list(let mediaType):
      return "genres/\(mediaType.rawValue)"
    }
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var sampleData: Data {
    switch self {
    case .list(let type):
      return stubbedResponse("trakt_genres_\(type)")
    }
  }
}
