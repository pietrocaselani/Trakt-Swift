import ObjectMapper

public struct SyncStats: ImmutableMappable {
  public let movies, shows, seasons, episodes: Int?
  
  public init(movies: Int?, shows: Int?, seasons: Int?, episodes: Int?) {
    self.movies = movies
    self.shows = shows
    self.seasons = seasons
    self.episodes = episodes
  }
  
  public init(map: Map) throws {
    self.movies = try? map.value("movies")
    self.shows = try? map.value("shows")
    self.seasons = try? map.value("seasons")
    self.episodes = try? map.value("episodes")
  }
  
  public func mapping(map: Map) {
    self.movies >>> map["movies"]
    self.shows >>> map["shows"]
    self.seasons >>> map["seasons"]
    self.episodes >>> map["episodes"]
  }
}
