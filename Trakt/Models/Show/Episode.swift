import Foundation

public final class Episode: StandardMediaEntity {
  public let season: Int
  public let number: Int
  public let ids: EpisodeIds
  public let absoluteNumber: Int?
  public let firstAired: Date?
  public let runtime: Int?

	private enum CodingKeys: String, CodingKey {
		case season, number, ids, runtime
		case absoluteNumber = "number_abs"
		case firstAired = "first_aired"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.season = try container.decode(Int.self, forKey: .season)
		self.number = try container.decode(Int.self, forKey: .number)
		self.ids = try container.decode(EpisodeIds.self, forKey: .ids)
		self.absoluteNumber = try container.decodeIfPresent(Int.self, forKey: .season)
		self.runtime = try container.decodeIfPresent(Int.self, forKey: .season)

		let firstAired = try container.decodeIfPresent(String.self, forKey: .firstAired)
		self.firstAired = TraktDateTransformer.dateTimeTransformer.transformFromJSON(firstAired)

		try super.init(from: decoder)
	}

  public override var hashValue: Int {
    var hash = super.hashValue ^ season.hashValue ^ number.hashValue ^ ids.hashValue
    
    if let absoluteNumberHash = absoluteNumber?.hashValue {
      hash = hash ^ absoluteNumberHash
    }
    
    if let firstAiredHash = firstAired?.hashValue {
      hash = hash ^ firstAiredHash
    }
    
    return hash
  }
}
