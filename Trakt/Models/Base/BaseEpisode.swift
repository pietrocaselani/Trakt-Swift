//
//  BaseEpisode.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public final class BaseEpisode: ImmutableMappable {
	public var number: Int
	
	public var collectedAt: Date?
	public var plays: Int?
	public var lastWatchedAt: Date?
	public var completed: Bool?
	
	public required init(map: Map) throws {
		self.number = try map.value("number")
		
		self.collectedAt = try? map.value("collected_at", using: TraktDateTransformer.dateTimeTransformer)
		self.lastWatchedAt = try? map.value("last_watched_at", using: TraktDateTransformer.dateTimeTransformer)
		self.plays = try? map.value("plays")
		self.completed = try? map.value("completed")
	}
}
