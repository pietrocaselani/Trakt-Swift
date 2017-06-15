//
//  BaseEntity.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

public class BaseEntity: ImmutableMappable {
	
	public var title: String?
	public var overview: String?
	public var rating: Double?
	public var votes: Int?
	public var updatedAt: Date?
	public var translations: [String]?
	
	public required init(map: Map) throws {
		self.title = try? map.value("title")
		self.overview = try? map.value("overview")
		self.rating = try? map.value("rating")
		self.votes = try? map.value("votes")
		self.translations = try? map.value("available_translations")
		self.updatedAt = try? map.value("updated_at", using: TraktDateTransformer.dateTimeTransformer)
	}
	
}
