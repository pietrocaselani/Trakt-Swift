//
//  BaseMovie.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public final class BaseMovie: ImmutableMappable {
	public let movie: Movie
	public let plays: Int
	public let lastWatchedAt: Date
	public let collectAt: Date?
	public let listedAt: Date?
	
	public required init(map: Map) throws {
		self.movie = try map.value("movie")
		self.plays = try map.value("plays")
		self.lastWatchedAt = try map.value("last_watched_at", using: TraktDateTransformer.dateTimeTransformer)
		self.collectAt = try? map.value("collected_at", using: TraktDateTransformer.dateTimeTransformer)
		self.listedAt = try? map.value("listed_at", using: TraktDateTransformer.dateTimeTransformer)
	}
}
