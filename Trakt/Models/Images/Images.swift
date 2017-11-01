public final class Images: Codable, Hashable {
  public let avatar: ImageSizes

  public var hashValue: Int {
    return avatar.hashValue
  }

  public static func == (lhs: Images, rhs: Images) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
