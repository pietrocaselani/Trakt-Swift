//
//  BaseShow.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public final class BaseShow: ImmutableMappable {
	public var show: Show?
	public var seasons: [BaseSeason]?
	public var lastCollectedAt: Date?
	public var listedAt: Date?
	public var plays: Int?
	public var lastWatchedAt: Date?
	public var aired: Int?
	public var completed: Int?
	public var hiddenSeasons: [Season]?
	public var nextEpisode: Episode?
	
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
	
}
