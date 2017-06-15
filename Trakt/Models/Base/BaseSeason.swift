//
//  BaseSeason.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class BaseSeason: ImmutableMappable {
	public var number: Int
	public var episodes: [BaseEpisode]
	public var aired: Int?
	public var completed: Int?
	
	public required init(map: Map) throws {
		self.number = try map.value("number")
		self.episodes = try map.value("episodes")
		self.aired = try? map.value("aired")
		self.completed = try? map.value("completed")
	}
}
