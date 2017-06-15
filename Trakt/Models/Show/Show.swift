//
//  Show.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public final class Show: BaseEntity {
	public var year: Int
	public var ids: ShowIds
	
	public var firstAired: Date?
	public var airs: Airs?
	public var runtime: Int?
	public var certification: String?
	public var network: String?
	public var country: String?
	public var trailer: String?
	public var homepage: String?
	public var status: Status?
	public var language: String?
	public var genres: [String]?
	
	public required init(map: Map) throws {
		self.year = try map.value("year")
		self.ids = try map.value("ids")
		self.firstAired = try? map.value("first_aired", using: TraktDateTransformer.dateTimeTransformer)
		self.airs = try? map.value("airs")
		self.runtime = try? map.value("runtime")
		self.certification = try? map.value("certification")
		self.network = try? map.value("network")
		self.country = try? map.value("country")
		self.trailer = try? map.value("trailer")
		self.homepage = try? map.value("homepage")
		self.status = try? map.value("status")
		self.language = try? map.value("language")
		self.genres = try? map.value("genres")
		
		try super.init(map: map)
	}
	
}
