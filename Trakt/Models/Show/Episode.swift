//
//  Episode.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public final class Episode: BaseEntity {
	public var season: Int
	public var number: Int
	public var ids: EpisodeIds
	
	public var absoluteNumber: Int?
	public var firstAired: Date?
	
	public required init(map: Map) throws {
		self.season = try map.value("season")
		self.number = try map.value("number")
		self.ids = try map.value("ids")
		self.absoluteNumber = try? map.value("number_abs")
		self.firstAired = try? map.value("first_aired", using: TraktDateTransformer.dateTimeTransformer)
		
		try super.init(map: map)
	}
}
