public struct SyncItems: Codable {
  public let movies: [SyncMovie]?
  public let shows: [SyncShow]?
  public let episodes: [SyncEpisode]?
  public let ids: [Int]?

	private enum CodingKeys: String, CodingKey {
		case movies, shows, episodes, ids
	}
  
  public init(movies: [SyncMovie]? = nil, shows: [SyncShow]? = nil, episodes: [SyncEpisode]? = nil, ids: [Int]? = nil) {
    self.movies = movies
    self.shows = shows
    self.episodes = episodes
    self.ids = ids
  }

	public init(from decoder: Decoder) throws {
		let container = decoder.container(keyedBy: CodingKeys.self)

		self.movies = try container.decodeIfPresent([SyncMovie].self, forKey: .movies)
		self.shows = try container.decodeIfPresent([SyncShow].self, forKey: .shows)
		self.episodes = try container.decodeIfPresent([SyncEpisode].self, forKey: .episodes)
		self.ids = try container.decodeIfPresent([Int].self, forKey: .ids)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encodeIfPresent(movies, forKey: .movies)
		try container.encodeIfPresent(shows, forKey: .shows)
		try container.encodeIfPresent(episodes, forKey: .episodes)
		try container.encodeIfPresent(ids, forKey: .ids)
	}
  
  public init(map: Map) throws {
    self.movies = try? map.value("movies")
    self.shows = try? map.value("shows")
    self.episodes = try? map.value("episodes")
    self.ids = try? map.value("ids")
  }
  
  public func mapping(map: Map) {
    self.movies >>> map["movies"]
    self.shows >>> map["shows"]
    self.episodes >>> map["episodes"]
    self.ids >>> map["ids"]
  }  
}
