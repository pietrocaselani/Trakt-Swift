public struct User: Codable, Hashable {
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
		case username, name, vip, ids, location, about, gender, age, images
		case vipExecuteProducer = "vip_ep"
		case joinedAt = "joined_at"
		case isPrivate = "private"
	}

	public init(from decoder: Decoder) throws {
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
			throw TraktError.missingJSONValue(message: message)
		}

		self.joinedAt = joinedAtDate
	}

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.username, forKey: .username)
    try container.encode(self.isPrivate, forKey: .isPrivate)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.vip, forKey: .vip)
    try container.encode(self.vipExecuteProducer, forKey: .vipExecuteProducer)
    try container.encode(self.ids, forKey: .ids)
    try container.encode(self.location, forKey: .location)
    try container.encode(self.about, forKey: .about)
    try container.encode(self.gender, forKey: .gender)
    try container.encode(self.age, forKey: .age)
    try container.encode(self.images, forKey: .images)

    let joinedAtJSON = TraktDateTransformer.dateTimeTransformer.transformToJSON(self.joinedAt)
    try container.encode(joinedAtJSON, forKey: .joinedAt)
  }
}
