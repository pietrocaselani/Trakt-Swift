//
//  MostPlayedShow..swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class MostPlayedShow: ImmutableMappable {
	public let watcherCount, playCount, collectedCount, collectorCount: Int
	public let show: Show
	
	public required init(map: Map) throws {
		self.watcherCount = try map.value("watcher_count")
		self.playCount = try map.value("play_count")
		self.collectedCount = try map.value("collected_count")
		self.collectorCount = try map.value("collector_count")
		self.show = try map.value("show")
	}
}
