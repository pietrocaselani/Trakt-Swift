//
//  TrendingShow.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class TrendingShow: BaseTrendingEntity {
	public let show: Show
	
	public required init(map: Map) throws {
		self.show = try map.value("show")
		
		try super.init(map: map)
	}
	
}
