public final class ImageSizes: Codable, Hashable {
  public let full: String

	public init(full: String) {
		self.full = full
	}

  public var hashValue: Int {
    return full.hashValue
  }

  public static func == (lhs: ImageSizes, rhs: ImageSizes) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
