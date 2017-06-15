//
//  BaseTrendingEntity.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public class BaseTrendingEntity: ImmutableMappable {
	
	let watchers: Int
	
	public required init(map: Map) throws {
		self.watchers = try map.value("watchers")
	}
	
}
