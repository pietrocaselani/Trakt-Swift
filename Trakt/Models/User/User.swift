public final class User: Codable, Hashable {
  public let username: String
  public let isPrivate: Bool
  public let name: String
  public let vip: Bool
  public let vipExecuteProducer: Bool
  public let ids: UserIds
  public let joinedAt: Date
  public let location: String
  public let about: String
  public let gender: String
  public let age: Int
  public let images: Images

	private enum CodingKeys: String, CodingKey {
		case username, isPrivate, name, vip, ids, location, about, gender, age, images
		case vipExecuteProducer = "vip_ep"
		case joinedAt = "joined_at"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: User.self)

		self.username = try container.decode(String.self, .username)
		self.isPrivate = try container.decode(Bool.self, .isPrivate)
		self.name = try container.decode(String.self, .name)
		self.vip = try container.decode(Bool.self, .vip)
		self.vipExecuteProducer = try container.decode(Bool.self, .vipExecuteProducer)
		self.ids = try container.decode(UserIds.self, .ids)
		self.location = try container.decode(String.self, .location)
		self.about = try container.decode(String.self, .about)
		self.gender = try container.decode(String.self, .gender)
		self.age = try container.decode(Int.self, .age)
		self.images = try container.decode(Images.self, .images)

		let joinedAt = try container.decode(String.self, .joinedAt)
		self.joinedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(joinedAt)
	}

  public var hashValue: Int {
    var hash = username.hashValue ^ isPrivate.hashValue ^ name.hashValue ^ vip.hashValue ^ vipExecuteProducer.hashValue
    hash ^= ids.hashValue ^ joinedAt.hashValue ^ location.hashValue ^ about.hashValue ^ gender.hashValue
    return hash ^ age.hashValue ^ images.hashValue
  }

  public static func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
