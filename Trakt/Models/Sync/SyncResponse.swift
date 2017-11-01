public struct SyncResponse: Codable {
  public let added: SyncStats?
  public let existing: SyncStats?
  public let deleted: SyncStats?
  public let notFound: SyncStats?

	private enum CodingKeys: String, CodingKey {
		case added, existing, deleted
		case notFound = "not_found"
	}

  public init(added: SyncStats?, existing: SyncStats?, deleted: SyncStats?, notFound: SyncStats?) {
    self.added = added
    self.existing = existing
    self.deleted = deleted
    self.notFound = notFound
  }

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.added = try container.decodeIfPresent(SyncStats.self, forKey: .added)
		self.existing = try container.decodeIfPresent(SyncStats.self, forKey: .existing)
		self.deleted = try container.decodeIfPresent(SyncStats.self, forKey: .deleted)
		self.notFound = try container.decodeIfPresent(SyncStats.self, forKey: .notFound)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encodeIfPresent(added, forKey: .added)
		try container.encodeIfPresent(existing, forKey: .existing)
		try container.encodeIfPresent(deleted, forKey: .deleted)
		try container.encodeIfPresent(notFound, forKey: .notFound)
	}
}
