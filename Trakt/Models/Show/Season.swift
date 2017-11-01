public final class Season: Codable, Hashable {
  public let number: Int
  public let ids: SeasonIds
  public let overview: String?
  public let rating: Double?
  public let votes: Int?
  public let episodeCount: Int?
  public let airedEpisodes: Int?
  public let episodes: [Episode]?

	private enum CodingKeys: String, CodingKey {
		case number, ids, overview, rating, votes, episodes
		case episodeCount = "episode_count"
		case airedEpisodes = "aired_episodes"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.number = try container.decode(Int.self, forKey: .number)
		self.ids = try container.decode(SeasonIds.self, forKey: .ids)
		self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
		self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
		self.votes = try container.decodeIfPresent(Int.self, forKey: .votes)
		self.episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
		self.airedEpisodes = try container.decodeIfPresent(Int.self, forKey: .airedEpisodes)
		self.episodes = try container.decodeIfPresent([Episode].self, forKey: .episodes)
	}

  public var hashValue: Int {
    var hash = number.hashValue ^ ids.hashValue

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let ratingHash = rating?.hashValue {
      hash = hash ^ ratingHash
    }

    if let votesHash = votes?.hashValue {
      hash = hash ^ votesHash
    }

    if let episodeCounthash = episodeCount?.hashValue {
      hash = hash ^ episodeCounthash
    }

    if let airedEpisodesHash = airedEpisodes?.hashValue {
      hash = hash ^ airedEpisodesHash
    }

    episodes?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func == (lhs: Season, rhs: Season) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
