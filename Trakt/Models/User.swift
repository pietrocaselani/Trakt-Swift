//
//  User.swift
//  Trakt
//
//  Created by Pietro Caselani on 14/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation

import ObjectMapper

public final class User: ImmutableMappable {
	public let username, name, slug: String
	public let isPrivate, vip, vipEp: Bool
	
	public init(slug: String) {
		let count = slug.characters.count
		
		if count == 0 {
			fatalError("Trakt username can't be empty")
		}
		
		guard let regex = try? NSRegularExpression(pattern: "(-)+") else {
			fatalError("Impossible to build regex with pattern `(-)+")
		}
		
		let traktUsername = regex.stringByReplacingMatches(in: slug, options: .init(rawValue: 0),
		                                                   range: NSMakeRange(0, count), withTemplate: "-")
		
		self.slug = traktUsername
		
		self.username = ""
		self.name = ""
		self.isPrivate = false
		self.vip = false
		self.vipEp = false
	}
	
	public required init(map: Map) throws {
		self.username = try map.value("username")
		self.name = try map.value("name")
		self.isPrivate = try map.value("private")
		self.vip = try map.value("vip")
		self.vipEp = try map.value("vip_ep")
		self.slug = try map.value("ids.slug")
	}
	
}

extension User: CustomStringConvertible {
	
	public func mapping(map: Map) {
		self.username >>> map["username"]
		self.name >>> map["name"]
		self.isPrivate >>> map["private"]
		self.vip >>> map["vip"]
		self.vipEp >>> map["vip_ep"]
		self.slug >>> map["ids.slug"]
	}
	
	public var description: String { return self.toJSONString(prettyPrint: true) ?? "User is empty" }
	
}
