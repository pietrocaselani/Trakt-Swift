import ObjectMapper

public final class BaseSeason: ImmutableMappable, Hashable {
  public let number: Int
  public let episodes: [BaseEpisode]
  public let aired: Int?
  public let completed: Int?

  public init(map: Map) throws {
    self.number = try map.value("number")
    self.episodes = try map.value("episodes")
    self.aired = try? map.value("aired")
    self.completed = try? map.value("completed")
  }
  
  public var hashValue: Int {
    var hash = number.hashValue

    if let airedHash = aired?.hashValue {
      hash = hash ^ airedHash
    }

    if let completedHash = completed?.hashValue {
      hash = hash ^ completedHash
    }

    episodes.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func ==(lhs: BaseSeason, rhs: BaseSeason) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
