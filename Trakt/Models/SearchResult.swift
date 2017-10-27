import ObjectMapper

public final class SearchResult: ImmutableMappable {

  public let type: SearchType
  public let score: Double?
  public let movie: Movie?
  public let show: Show?

  public init(map: Map) throws {
    self.type = (try? map.value("type")) ?? .movie
    self.score = try? map.value("score")
    self.movie = try? map.value("movie")
    self.show = try? map.value("show")
  }
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
