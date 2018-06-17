import Moya

public enum Sync {
  case watched(type: WatchedType, extended: Extended)
  case addToHistory(items: SyncItems)
  case removeFromHistory(items: SyncItems)
	case history(type: HistoryType, id: Int, startAt: Date?, endAt: Date?)
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
		case .history(let type, let id, _, _):
			return "/history/\(type.rawValue)/\(id)"
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
		case .history(_, _, let startAt, let endAt):
			var params = [String: Any]()

			if let startDate = TraktDateTransformer.dateTimeTransformer.transformToJSON(startAt) {
				params["start_at"] = startDate
			}

			if let endDate = TraktDateTransformer.dateTimeTransformer.transformToJSON(endAt) {
				params["end_at"] = endDate
			}

			return .requestParameters(parameters: params, encoding: URLEncoding.default)
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
