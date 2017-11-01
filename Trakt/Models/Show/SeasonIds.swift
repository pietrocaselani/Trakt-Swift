public final class SeasonIds: Codable, Hashable {
  public let tvdb: Int
  public let tmdb: Int
  public let trakt: Int
  public let tvrage: Int?

	private enum CodingKeys: String, CodingKey {
		case tvdb, tmdb, trakt, tvrage
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.tvdb = try container.decode(Int.self, forKey: .tvdb)
		self.tmdb = try container.decode(Int.self, forKey: .tmdb)
		self.trakt = try container.decode(Int.self, forKey: .trakt)
		self.tvrage = try container.decodeIfPresent(Int.self, forKey: .tvrage)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(tvdb, forKey: .tvdb)
		try container.encode(tmdb, forKey: .tmdb)
		try container.encode(trakt, forKey: .trakt)
		try container.encodeIfPresent(tvrage, forKey: .tvrage)
	}
  
  public var hashValue: Int {
    var hash = tvdb.hashValue ^ tmdb.hashValue ^ trakt.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    
    return hash
  }
  
  public static func == (lhs: SeasonIds, rhs: SeasonIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
