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
		let container = decoder.container(keyedBy: CodingKeys.self)

		self.season = try container.decode(Int.self, forKey: .season)
		self.number = try container.decode(Int.self, forKey: .number)
		self.ids = try container.decode(EpisodeIds.self, forKey: .ids)
		self.absoluteNumber = try container.decodeIfPresent(Int.self, forKey: .season)
		self.runtime = try container.decodeIfPresent(Int.self, forKey: .season)
		let firstAired = try container.decodeIfPresent(String.self, forKey: .firstAired)
		self.firstAired = TraktDateTransformer.dateTimeTransformer.transformFromJSON(firstAired)
	}
  
  public required init(map: Map) throws {
    self.season = try map.value("season")
    self.number = try map.value("number")
    self.ids = try map.value("ids")
    self.absoluteNumber = try? map.value("number_abs")
    self.firstAired = try? map.value("first_aired", using: TraktDateTransformer.dateTimeTransformer)
    self.runtime = try? map.value("runtime")
    try super.init(map: map)
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
