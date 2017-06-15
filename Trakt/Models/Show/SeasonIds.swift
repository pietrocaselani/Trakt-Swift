//
//  SeasonIds.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class SeasonIds: ImmutableMappable {
	public var tvdb: Int
	public var tmdb: Int
	public var trakt: Int
	public var tvrage: Int?
	
	public required init(map: Map) throws {
		self.tvdb = try map.value("tvdb")
		self.tmdb = try map.value("tmdb")
		self.trakt = try map.value("trakt")
		self.tvrage = try? map.value("tvrage")
	}
	
	public func mapping(map: Map) {
		self.tvdb >>> map["tvdb"]
		self.tmdb >>> map["tmdb"]
		self.trakt >>> map["trakt"]
		self.tvrage >>> map["tvrage"]
	}
}
