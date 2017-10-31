public final class Airs: Codable, Hashable {
  public let day: String
  public let time: String
  public let timezone: String

  public var hashValue: Int {
    return day.hashValue ^ time.hashValue ^ timezone.hashValue
  }

  public static func == (lhs: Airs, rhs: Airs) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
