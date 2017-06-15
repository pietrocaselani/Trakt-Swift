//
//  Shows.swift
//  Trakt
//
//  Created by Pietro Caselani on 23/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

public enum Shows {
	case trending(page: Int, limit: Int, extended: Extended)
	case popular(page: Int, limit: Int, extended: Extended)
	case played(period: Period?, page: Int, limit: Int, extended: Extended)
	case watched(period: Period?, page: Int, limit: Int, extended: Extended)
	case collected(period: Period?, page: Int, limit: Int, extended: Extended)
	case anticipated(page: Int, limit: Int, extended: Extended)
	case summary(showId: String, extended: Extended)
	
	case watchedProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool)
}

extension Shows: TraktType {
	
	public var path: String {
		switch self {
		case .trending:
			return "/shows/trending"
		case .popular:
			return "/shows/popular"
		case .played(let period, _, _, _):
			var path = "/shows/played"
			if period != nil {
				path.append("/(period)")
			}
			
			return path
		case .watched(let period, _, _, _):
			var path = "/shows/watched"
			if period != nil {
				path.append("/(period)")
			}
			
			return path
		case .collected(let period, _, _, _):
			var path = "/shows/collected"
			if period != nil {
				path.append("/(period)")
			}
			
			return path
		case .anticipated:
			return "/shows/anticipated"
		case .summary(let showId, _):
			return "/shows/\(showId)"
		case .watchedProgress(let showId, _, _, _):
			return "/shows/\(showId)/progress/watched"
		}
	}
	
	public var parameters: [String : Any]? {
		switch self {
		case .trending(let page, let limit, let extended),
		     .popular(let page, let limit, let extended),
		     .played(_, let page, let limit, let extended),
		     .watched(_, let page, let limit, let extended),
		     .collected(_, let page, let limit, let extended),
		     .anticipated(let page, let limit, let extended):
			return ["page" : page, "limit" : limit, "extended" : extended.rawValue]
		case .summary(_, let extended):
			return ["extended" : extended.rawValue]
		case .watchedProgress(_, let hidden, let specials, let countSpecials):
			return ["hidden" : hidden, "specials" : specials, "count_specials" : countSpecials]
		}
	}
	
	public var sampleData: Data {
		return "".utf8Encoded
	}
	
}
