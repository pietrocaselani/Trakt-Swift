public final class Settings: Codable, Hashable {
  public let user: User

	public var hashValue: Int {
		return user.hashValue
	}

	public static func == (lhs: Settings, rhs: Settings) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
