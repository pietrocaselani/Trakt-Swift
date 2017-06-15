//
//  TraktV2.swift
//  Trakt
//
//  Created by Pietro Caselani on 14/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya
import Result
import Moya_ObjectMapper

public class TraktV2 {
	public let clientId: String
	public let clientSecret, redirectURL: String?
	public let oauthURL: URL?

	var plugins: [PluginType]
	
	public var accessToken: Token? {
		didSet {
			let index = self.plugins.index { (plugin) -> Bool in
				plugin is AccessTokenPlugin
			}
			
			if let index = index {
				plugins.remove(at: index)
			}
			
			if let token = accessToken {
				plugins.append(AccessTokenPlugin(token: token.accessToken))
				saveToken(token)
			}
		}
	}
	
	public convenience init(clientId: String) {
		self.init(clientId: clientId, clientSecret: nil, redirectURL: nil)
	}
	
	public init(clientId: String, clientSecret: String?, redirectURL: String?) {
		self.clientId = clientId
		self.clientSecret = clientSecret
		self.redirectURL = redirectURL
		
		self.plugins = [PluginType]()
		
		if TraktV2.debug {
			plugins.append(NetworkLoggerPlugin())
		}
		
		if let redirectURL = redirectURL {
			self.oauthURL = URL(string: "https://trakt.tv\(TraktV2.OAuth2AuthorizationPath)?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectURL)")
		} else {
			self.oauthURL = nil
		}
		
		loadToken()
	}
	
	public func handleAuthentication(request: URLRequest, completion: @escaping (Result<Any, TraktError>) -> ()) -> TraktError? {
		guard let secret = clientSecret, let redirectURL = redirectURL else {
			return TraktError.cantAuthenticate("Trying to authenticate without a secret or redirect URL")
		}
		
		let url = request.url
		
		if let url = url, let host = url.host {
			if redirectURL.contains(host) {
				let components = URLComponents(string: url.absoluteString)
				
				let code = components?.queryItems?.first(where: { (item) -> Bool in
					item.name == "code"
				})
				
				if let value = code?.value {
					let target = Authentication.accessToken(code: value, clientId: self.clientId, clientSecret: secret, redirectURL: redirectURL, grantType: "authorization_code")
					
					self.authentication.request(target) { result in
						switch result {
						case .success(let response):
							do {
								self.accessToken = try response.mapObject(Token.self)
								completion(Result(true))
							} catch {
								let statusCode = response.statusCode
								let responseString = try? response.mapString()
								
								completion(Result(TraktError.authenticateError(statusCode, responseString)))
							}
							
						case .failure(let error):
							completion(Result(error))
						}
					}
				}
			}
			return nil
		}
		
		return TraktError.cantAuthenticate("Trying to authenticate without a secret or redirect URL")
	}
	
	public func hasValidToken() -> Bool {
		return accessToken?.expiresIn.compare(Date()) == .orderedDescending
	}
	
	private func loadToken() {
		let tokenData = UserDefaults.standard.object(forKey: TraktV2.accessTokenKey) as? Data
		if let tokenData = tokenData, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token {
			self.accessToken = token
		}
	}
	
	private func saveToken(_ token: Token) {
		let tokenData = NSKeyedArchiver.archivedData(withRootObject: token)
		UserDefaults.standard.set(tokenData, forKey: TraktV2.accessTokenKey)
	}
	
}
