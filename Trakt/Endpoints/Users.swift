//
//  Users.swift
//  Trakt
//
//  Created by Pietro Caselani on 14/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

public enum Users {
	case profile(user: User)
	
}

extension Users: TraktType {
	
	public var path: String {
		switch self {
		case .profile(let user):
			return "/users/\(user.slug)"
		}
	}
	
	public var method: Moya.Method {
		switch self {
		case .profile:
			return .get
		}
	}
	
	public var parameters: [String : Any]? {
		switch self {
		case .profile:
			return nil
		}
	}
	
	public var sampleData: Data {
		switch self {
		case .profile(let username):
			return "{\"username\": \"sean\", \"private\": false, \"name\": \"Sean Rudford\", \"vip\": true, \"vip_ep\": true, \"ids\": {\"slug\": \"\(username)\"}}".utf8Encoded
		}
	}
	
}
