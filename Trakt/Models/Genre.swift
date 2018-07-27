public final class Genre: Codable, Hashable {
  public let name: String
  public let slug: String

  public init(name: String, slug: String) {
    self.name = name
    self.slug = slug
  }

  public var hashValue: Int {
    return name.hashValue ^ slug.hashValue
  }

  public static func == (lhs: Genre, rhs: Genre) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
