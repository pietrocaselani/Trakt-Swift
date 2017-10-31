import Foundation

public final class BaseShow: Codable, Hashable {
  public let show: Show?
  public let seasons: [BaseSeason]?
  public let lastCollectedAt: Date?
  public let listedAt: Date?
  public let plays: Int?
  public let lastWatchedAt: Date?
  public let aired: Int?
  public let completed: Int?
  public let hiddenSeasons: [Season]?
  public let nextEpisode: Episode?

  public required init(map: Map) throws {
    self.show = try? map.value("show")
    self.seasons = try? map.value("seasons")
    self.lastCollectedAt = try? map.value("last_collected_at", using: TraktDateTransformer.dateTimeTransformer)
    self.listedAt = try? map.value("listed_at", using: TraktDateTransformer.dateTimeTransformer)
    self.plays = try? map.value("plays")
    self.lastWatchedAt = try? map.value("last_watched_at", using: TraktDateTransformer.dateTimeTransformer)
    self.aired = try? map.value("aired")
    self.completed = try? map.value("completed")
    self.hiddenSeasons = try? map.value("hidden_seasons")
    self.nextEpisode = try? map.value("next_episode")
  }

  public var hashValue: Int {
    var hash = 11

    if let showHash = show?.hashValue {
      hash = hash ^ showHash
    }

    seasons?.forEach { hash = hash ^ $0.hashValue }

    if let lastCollectedAtHash = lastCollectedAt?.hashValue {
      hash = hash ^ lastCollectedAtHash
    }

    if let listedAtHash = listedAt?.hashValue {
      hash = hash ^ listedAtHash
    }

    if let playsHash = plays?.hashValue {
      hash = hash ^ playsHash
    }

    if let lastWatchedAtHash = lastWatchedAt?.hashValue {
      hash = hash ^ lastWatchedAtHash
    }

    if let airedHash = aired?.hashValue {
      hash = hash ^ airedHash
    }

    if let completedHash = completed?.hashValue {
      hash = hash ^ completedHash
    }

    hiddenSeasons?.forEach { hash = hash ^ $0.hashValue }

    if let nextEpisodeHash = nextEpisode?.hashValue {
      hash = hash ^ nextEpisodeHash
    }

    return hash
  }

  public static func == (lhs: BaseShow, rhs: BaseShow) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
