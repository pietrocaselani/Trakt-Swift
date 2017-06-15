//
//  Authentication.swift
//  Trakt
//
//  Created by Pietro Caselani on 15/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

public enum Authentication {
	case authorize(responseType: String, clientId: String, redirectURL: String, state: String?)
	
	case accessToken(code: String, clientId: String, clientSecret: String, redirectURL: String, grantType: String)
}

extension Authentication: TraktType {
	
	public var path: String {
		switch self {
		case .authorize:
			return TraktV2.OAuth2AuthorizationPath
		case .accessToken:
			return TraktV2.OAuth2TokenPath
		}
	}
	
	public var method: Moya.Method {
		switch self {
		case .authorize:
			return .get
		case .accessToken:
			return .post
		}
	}
	
	public var parameters: [String : Any]? {
		switch self {
		case .authorize(let responseType, let clientId, let redirectURL, let state):
			var params = ["response_type": responseType, "client_id": clientId, "redirect_uri": redirectURL]
			
			if let state = state {
				params["state"] = state
			}
			
			return params
		case .accessToken(let code, let clientId, let clientSecret, let redirectURL, let grantType):
			return ["code": code,
			        "client_id": clientId,
			        "client_secret": clientSecret,
			        "redirect_uri": redirectURL,
			        "grant_type": grantType]
		}
	}
	
	public var parameterEncoding: ParameterEncoding {
		switch self {
		case .accessToken:
			return JSONEncoding.default
		default:
			return URLEncoding.default
		}
	}
	
	public var sampleData: Data {
		return "OAuth2Response".utf8Encoded
	}
}
