public final class SearchResult: Codable {
  public let type: SearchType
  public let score: Double?
  public let movie: Movie?
  public let show: Show?
}

extension SearchResult: Hashable {

  public var hashValue: Int {
    var hash = type.rawValue.hashValue

    if let scoreHash = score?.hashValue {
      hash ^= scoreHash
    }

    if let movieHash = movie?.hashValue {
      hash ^= movieHash
    }

    if let showHash = show?.hashValue {
      hash ^= showHash
    }

    return hash
  }

  public static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
