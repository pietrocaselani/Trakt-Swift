//
//  TraktError.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

public enum TraktError: Swift.Error {
	
	case cantAuthenticate(String)
	case authenticateError(Int, String?)
	
}
