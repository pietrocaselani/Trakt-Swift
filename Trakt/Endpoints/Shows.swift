import Moya

public enum Shows {
  case trending(page: Int, limit: Int, extended: Extended)
  case popular(page: Int, limit: Int, extended: Extended)
  case played(period: Period, page: Int, limit: Int, extended: Extended)
  case watched(period: Period, page: Int, limit: Int, extended: Extended)
  case collected(period: Period, page: Int, limit: Int, extended: Extended)
  case anticipated(page: Int, limit: Int, extended: Extended)
  case summary(showId: String, extended: Extended)
  case watchedProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool)
}

extension Shows: TraktType {

  public var path: String {
    switch self {
    case .trending:
      return "/shows/trending"
    case .popular:
      return "/shows/popular"
    case .played(let period, _, _, _):
      return "/shows/played/\(period)"
    case .watched(let period, _, _, _):
      return "/shows/watched/\(period)"
    case .collected(let period, _, _, _):
      return "/shows/collected/\(period)"
    case .anticipated:
      return "/shows/anticipated"
    case .summary(let showId, _):
      return "/shows/\(showId)"
    case .watchedProgress(let showId, _, _, _):
      return "/shows/\(showId)/progress/watched"
    }
  }

  public var task: Task {
    let params: [String: Any]
    switch self {
    case .trending(let page, let limit, let extended),
         .popular(let page, let limit, let extended),
         .played(_, let page, let limit, let extended),
         .watched(_, let page, let limit, let extended),
         .collected(_, let page, let limit, let extended),
         .anticipated(let page, let limit, let extended):
      params = ["page": page, "limit": limit, "extended": extended.rawValue]
    case .summary(_, let extended):
      params = ["extended": extended.rawValue]
    case .watchedProgress(_, let hidden, let specials, let countSpecials):
      params = ["hidden": hidden, "specials": specials, "count_specials": countSpecials]
    }

    return .requestParameters(parameters: params, encoding: URLEncoding.default)
  }

  public var authorizationType: AuthorizationType {
    switch self {
    case .watchedProgress:
      return .bearer
    default:
      return .none
    }
  }

  public var sampleData: Data {
    switch self {
    case .trending:
      return stubbedResponse("trakt_shows_trending")
    case .summary:
      return stubbedResponse("trakt_shows_summary")
    case .watchedProgress:
      return stubbedResponse("trakt_shows_watchedprogress")
    default:
      return Data()
    }
  }
}
