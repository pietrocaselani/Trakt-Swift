//
//  Period.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

public enum Period: String, Equatable {
	case weekly = "weekly"
	case monthly = "monthly"
	case yearly = "yearly"
	case all = "all"
	
	public static func ==(lhs: Period, rhs: Period) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
