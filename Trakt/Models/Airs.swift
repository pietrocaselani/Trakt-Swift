import ObjectMapper

public final class Airs: ImmutableMappable, Hashable {
  public let day: String
  public let time: String
  public let timezone: String

  public required init(map: Map) throws {
    self.day = try map.value("day")
    self.time = try map.value("time")
    self.timezone = try map.value("timezone")
  }

  public var hashValue: Int {
    return day.hashValue ^ time.hashValue ^ timezone.hashValue
  }

  public static func == (lhs: Airs, rhs: Airs) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
