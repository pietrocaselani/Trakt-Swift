//
//  TraktV2+Constants.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Foundation

extension TraktV2 {
	public static var debug = false
	
	public static let baseURL = URL(string: "https://\(TraktV2.apiHost)")!
	public static let siteURL = URL(string: "https://trakt.tv")!
	
	static let OAuth2AuthorizationPath = "/oauth/authorize"
	static let OAuth2TokenPath = "/oauth/token"
	
	static let headerAuthorization = "Authorization"
	static let headerContentType = "Content-type"
	static let headerTraktAPIKey = "trakt-api-key"
	static let headerTraktAPIVersion = "trakt-api-version"
	
	static let contentTypeJSON = "application/json"
	static let apiVersion = "2"
	static let apiHost = "api.trakt.tv"
	
	static let accessTokenKey = "trakt_token"
}
