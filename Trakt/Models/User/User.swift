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
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.username = try container.decode(String.self, forKey: .username)
		self.isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
		self.name = try container.decode(String.self, forKey: .name)
		self.vip = try container.decode(Bool.self, forKey: .vip)
		self.vipExecuteProducer = try container.decode(Bool.self, forKey: .vipExecuteProducer)
		self.ids = try container.decode(UserIds.self, forKey: .ids)
		self.location = try container.decode(String.self, forKey: .location)
		self.about = try container.decode(String.self, forKey: .about)
		self.gender = try container.decode(String.self, forKey: .gender)
		self.age = try container.decode(Int.self, forKey: .age)
		self.images = try container.decode(Images.self, forKey: .images)

		let joinedAt = try container.decode(String.self, forKey: .joinedAt)
		guard let joinedAtDate = TraktDateTransformer.dateTimeTransformer.transformFromJSON(joinedAt) else {
			let message = "JSON key: joined_at - Value: \(joinedAt) - Error: Could not transform to date"
			throw TraktError.missingJSONValie(message: message)
		}

		self.joinedAt = joinedAtDate
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
