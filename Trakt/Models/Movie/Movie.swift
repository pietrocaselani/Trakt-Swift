//
//  Movie.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public final class Movie: BaseEntity {
	public let year: Int
	public let ids: MovieIds
	
	public let certification: String?
	public let tagline: String?
	public let released: Date?
	public let runtime: Int?
	public let trailer: String?
	public let homepage: String?
	public let language: String?
	public let genres: [String]?
	
	public required init(map: Map) throws {
		self.year = try map.value("year")
		self.ids = try map.value("ids")
		self.certification = try? map.value("certification")
		self.tagline = try? map.value("tagline")
		self.released = try? map.value("released", using: TraktDateTransformer.dateTransformer)
		self.runtime = try? map.value("runtime")
		self.trailer = try? map.value("trailer")
		self.homepage = try? map.value("homepage")
		self.language = try? map.value("language")
		self.genres = try? map.value("genres")
		
		try super.init(map: map)
	}
	
}
