public final class Genre: Codable, Hashable {
  public let name: String
  public let slug: String

  public var hashValue: Int {
    return name.hashValue ^ slug.hashValue
  }

  public static func == (lhs: Genre, rhs: Genre) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
