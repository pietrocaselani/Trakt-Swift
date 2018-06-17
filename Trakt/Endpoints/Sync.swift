import Moya

public enum Sync {
  case watched(type: WatchedType, extended: Extended)
  case addToHistory(items: SyncItems)
  case removeFromHistory(items: SyncItems)
  case history(params: HistoryParameters?)
}

extension Sync: TraktType {
  public var path: String {
    switch self {
    case .watched(let type, _):
      return "/sync/watched/\(type.rawValue)"
    case .addToHistory:
      return "sync/history"
    case .removeFromHistory:
      return "/sync/history/remove"
		case .history(let parameters):
      var path = "sync/history"

      guard let params = parameters else {
        return path
      }

      if let type = params.type {
        path = "\(path)/\(type.rawValue)"
      }

      if let id = params.id {
        path = "\(path)/\(id)"
      }

			return path
    }
  }

  public var method: Moya.Method {
    switch self {
    case .addToHistory, .removeFromHistory:
      return .post
    default:
      return .get
    }
  }

  public var task: Task {
    switch self {
    case .watched(_, let extended):
      return .requestParameters(parameters: ["extended": extended.rawValue], encoding: URLEncoding.default)
		case .history(let parameters):
      guard let params = parameters else {
        return .requestPlain
      }

			var urlParams = [String: Any]()

			if let startDate = TraktDateTransformer.dateTimeTransformer.transformToJSON(params.startAt) {
				urlParams["start_at"] = startDate
			}

			if let endDate = TraktDateTransformer.dateTimeTransformer.transformToJSON(params.startAt) {
				urlParams["end_at"] = endDate
			}

			return .requestParameters(parameters: urlParams, encoding: URLEncoding.default)
    case .addToHistory(let items), .removeFromHistory(let items):
      return .requestJSONEncodable(items)
    }
  }

  public var authorizationType: AuthorizationType {
    return .bearer
  }

  public var sampleData: Data {
    switch self {
    case .watched(let type, _):
      let fileName = type == .shows ? "trakt_sync_watched_shows" : "trakt_sync_watched_movies"
      return stubbedResponse(fileName)
		case .addToHistory(_):
      return stubbedResponse("trakt_sync_addtohistory")
		case .removeFromHistory(_):
      return stubbedResponse("trakt_sync_removefromhistory")
		case .history:
			return stubbedResponse("trakt_sync_history")
    }
  }
}
