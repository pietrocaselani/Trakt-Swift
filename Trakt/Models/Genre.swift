import ObjectMapper

public final class Genre: ImmutableMappable, Hashable {
  public let name: String
  public let slug: String

  public init(name: String, slug: String) {
    self.name = name
    self.slug = slug
  }

  public init(map: Map) throws {
    self.name = try map.value("name")
    self.slug = try map.value("slug")
  }

  public var hashValue: Int {
    return name.hashValue ^ slug.hashValue
  }

  public static func == (lhs: Genre, rhs: Genre) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
