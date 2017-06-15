//
//  ShowIds.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class ShowIds: BaseIds {
	public var slug: String
	public var tvdb: Int
	public var tvrage: Int?
	
	public required init(map: Map) throws {
		self.slug = try map.value("slug")
		self.tvdb = try map.value("tvdb")
		self.tvrage = try? map.value("tvrage")
		
		try super.init(map: map)
	}
	
	public override func mapping(map: Map) {
		self.slug >>> map["slug"]
		self.tvdb >>> map["tvdb"]
		self.tvrage >>> map["tvrage"]
	}
}
