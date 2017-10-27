import ObjectMapper

public final class ImageSizes: ImmutableMappable, Hashable {
  public let full: String

  public init(map: Map) throws {
    self.full = try map.value("full")
  }

  public func mapping(map: Map) {
    full >>> map["full"]
  }

  public var hashValue: Int {
    return full.hashValue
  }

  public static func == (lhs: ImageSizes, rhs: ImageSizes) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
