//
//  Extended.swift
//  Trakt
//
//  Created by Pietro Caselani on 14/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

public enum Extended: String, Equatable {
	case defaultMin = "min"
	case full = "full"
	case noSeasons = "noseasons"
	case episodes = "episodes"
	case fullEpisodes = "full,episodes"
	
	public static func ==(lhs: Extended, rhs: Extended) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
