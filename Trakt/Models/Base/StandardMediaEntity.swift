public class StandardMediaEntity: Codable, Hashable {
  public var title: String?
  public var overview: String?
  public var rating: Double?
  public var votes: Int?
  public var updatedAt: Date?
  public var translations: [String]?

	private enum CodingKeys: String, CodingKey {
		case title
		case overview
		case rating
		case votes
		case updatedAt = "updated_at"
		case translations = "available_translations"
	}

	public required init(from decoder: Decoder) throws {
		let container = decoder.container(keyedBy: CodingKeys.self)

		self.title = container.decodeIfPresent(String.self, forKey: .title)
		self.overview = container.decodeIfPresent(String.self, forKey: .overview)
		self.rating = container.decodeIfPresent(Double.self, forKey: .rating)
		self.votes = container.decodeIfPresent(Int.self, forKey: .votes)
		self.translations = container.decodeIfPresent([String.self], forKey: .translations)

		let updatedAt = container.decodeIfPresent(String.self, forKey: .updatedAt)
		self.updatedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(updatedAt)
	}

  public var hashValue: Int {
    var hash = 0

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let ratingHash = rating?.hashValue {
      hash = hash ^ ratingHash
    }

    if let votesHash = votes?.hashValue {
      hash = hash ^ votesHash
    }

    if let updatedAtHash = updatedAt?.hashValue {
      hash = hash ^ updatedAtHash
    }

    translations?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func == (lhs: StandardMediaEntity, rhs: StandardMediaEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
