//
//  Trakt_StringExtensions.swift
//  Trakt
//
//  Created by Pietro Caselani on 15/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation

extension String {
	var urlEscaped: String {
		return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
	
	var utf8Encoded: Data {
		return self.data(using: .utf8)!
	}
}
