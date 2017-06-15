//
//  BaseIds.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public class BaseIds: ImmutableMappable {
	public let trakt: Int
	public let tmdb: Int?
	public let imdb: String?
	
	public required init(map: Map) throws {
		self.trakt = try map.value("trakt")
		self.tmdb = try? map.value("tmdb")
		self.imdb = try? map.value("imdb")
	}
	
	public func mapping(map: Map) {
		self.trakt >>> map["trakt"]
		self.tmdb >>> map["tmdb"]
		self.imdb >>> map["imdb"]
	}
}
