//
//  Season.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class Season: ImmutableMappable {
	public var number: Int
	public var ids: SeasonIds
	
	public var overview: String?
	public var rating: Double?
	public var votes: Int?
	public var episodeCount: Int?
	public var airedEpisodes: Int?
	public var episodes: [Episode]?
	
	public required init(map: Map) throws {
		self.number = try map.value("number")
		self.ids = try map.value("ids")
		self.overview = try? map.value("overview")
		self.rating = try? map.value("rating")
		self.votes = try? map.value("votes")
		self.episodeCount = try? map.value("episode_count")
		self.airedEpisodes = try? map.value("aired_episodes")
		self.episodes = try? map.value("episodes")
	}
}
