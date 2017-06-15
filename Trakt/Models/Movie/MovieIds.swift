//
//  MovieIds.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class MovieIds: BaseIds {
	public let slug: String
	
	public required init(map: Map) throws {
		self.slug = try map.value("slug")
		
		try super.init(map: map)
	}
	
	public override func mapping(map: Map) {
		self.slug >>> map["slug"]
	}
}
