//
//  Airs.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import ObjectMapper

public final class Airs: ImmutableMappable {
	public let day: String
	public let time: String
	public let timezone: String
	
	public required init(map: Map) throws {
		self.day = try map.value("day")
		self.time = try map.value("time")
		self.timezone = try map.value("timezone")
	}
}
