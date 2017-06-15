//
//  AnticipatedShow.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class AnticipatedShow: ImmutableMappable {
	public let listCount: Int
	public let show: Show
	
	public required init(map: Map) throws {
		self.listCount = try map.value("list_count")
		self.show = try map.value("show")
	}
}
