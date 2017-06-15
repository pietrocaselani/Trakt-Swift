//
//  TraktDateTransformer.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation
import ObjectMapper

struct TraktDateTransformer: TransformType {
	typealias Object = Date
	typealias JSON = String
	
	static let dateTimeTransformer = TraktDateTransformer(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'")
	static let dateTransformer = TraktDateTransformer(format: "yyyy'-'MM'-'dd")
	
	private let dateFormetter: DateFormatter
	
	private init(format: String) {
		dateFormetter = DateFormatter()
		dateFormetter.dateFormat = format
	}
	
	func transformFromJSON(_ value: Any?) -> Date? {
		if let stringDate = value as? String {
			return dateFormetter.date(from: stringDate)
		}
		
		return nil
	}
	
	func transformToJSON(_ value: Date?) -> String? {
		if let date = value {
			return dateFormetter.string(from: date)
		}
		
		return nil
	}
}
