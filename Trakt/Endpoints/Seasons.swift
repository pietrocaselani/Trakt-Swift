//
//  Seasons.swift
//  Trakt
//
//  Created by Pietro Caselani on 28/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

public enum Seasons {
	case season(showId: String, seasonNumber: Int, extended: Extended)
}

extension Seasons: TraktType {
	
	public var path: String {
		switch self {
		case .season(let showId, let seasonNumber, _):
			return "/shows/\(showId)/seasons/\(seasonNumber)"
		}
	}
	
	public var parameters: [String : Any]? {
		switch self {
		case .season(_, _, let extended):
			return ["extended" : extended.rawValue]
		}
	}
	
	public var sampleData: Data {
		return Data()
	}
	
}
