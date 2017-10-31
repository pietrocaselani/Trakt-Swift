public final class EpisodeIds: BaseIds {
  public let tvdb: Int
  public let tvrage: Int?

	private enum CodingKeys: String, CodingKey {
		case tvdb, tvrage
	}

  public init(trakt: Int, tmdb: Int?, imdb: String?, tvdb: Int, tvrage: Int?) {
    self.tvdb = tvdb
    self.tvrage = tvrage
    super.init(trakt: trakt, tmdb: tmdb, imdb: imdb)
  }

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.tvdb = container.decode(Int.self, forKey: .tvdb)
		self.tvrage = container.decodeIfPresent(Int.self, forKey: .tvrage)

		super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(tvdb, forKey: .tvdb)
		try container.encodeIfPresent(tvrage, forKey: .tvrage)

		super.encode(to: encoder)
	}
  
  public override var hashValue: Int {
    var hash = super.hashValue ^ tvdb.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    return hash
  }

  public override var description: String {
    return "\(super.description), tvdb: \(tvdb), tvrage: \(String(describing: tvrage))"
  }
}
