import ObjectMapper

public final class TrendingMovie: BaseTrendingEntity {
  public let movie: Movie

  public required init(map: Map) throws {
    self.movie = try map.value("movie")
    try super.init(map: map)
  }

  public override var hashValue: Int {
    return super.hashValue ^ movie.hashValue
  }
}
