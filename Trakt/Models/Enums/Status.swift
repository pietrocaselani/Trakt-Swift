//
//  Status.swift
//  Trakt
//
//  Created by Pietro Caselani on 22/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

public enum Status: String, Equatable {
	case ended = "ended"
	case returning = "returning series"
	case canceled = "canceled"
	case inProduction = "in production"
	
	public static func ==(lhs: Status, rhs: Status) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
