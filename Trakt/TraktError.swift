public enum TraktError: Error, Hashable {
	case cantAuthenticate(message: String)
	case authenticateError(statusCode: Int, response: String?)
	case missingJSONValue(message: String)

	public var hashValue: Int {
		var hash = self.localizedDescription.hashValue

		switch self {
		case .cantAuthenticate(let message):
			hash ^= message.hashValue
		case .authenticateError(let statusCode, let response):
			if let responseHash = response?.hashValue {
				hash ^= responseHash
			}
			hash ^= statusCode.hashValue
		case .missingJSONValue(let message):
			hash ^= message.hashValue
		}

		return hash
	}

	public static func == (lhs: TraktError, rhs: TraktError) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
