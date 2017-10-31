public final class TrendingShow: BaseTrendingEntity {
  public let show: Show

	private enum CodingKeys: String, CodingKey {
		case show
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.show = container.decode(Show.self, .show)

		super.init(from: decoder)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		container.encode(show, forKey: .show)

		super.encode(to: encoder)
	}

  public override var hashValue: Int {
    return super.hashValue ^ show.hashValue
  }
}
