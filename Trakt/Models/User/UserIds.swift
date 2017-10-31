public final class UserIds: Codable, Hashable {
  public let slug: String

  public var hashValue: Int {
    return slug.hashValue
  }

  public static func == (lhs: UserIds, rhs: UserIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
