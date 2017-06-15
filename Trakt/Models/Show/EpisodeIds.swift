//
//  EpisodeIds.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class EpisodeIds: BaseIds {
	public var tvdb: Int
	public var tvrage: Int?
	
	public required init(map: Map) throws {
		self.tvdb = try map.value("tvdb")
		self.tvrage = try? map.value("tvrage")
		
		try super.init(map: map)
	}
	
	public override func mapping(map: Map) {
		self.tvdb >>> map["tvdb"]
		self.tvrage >>> map["tvrage"]
	}
}
