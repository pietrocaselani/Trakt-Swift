//
//  TraktV2+Endpoints.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

extension TraktV2 {
	
	public var users: RxMoyaProvider<Users> {
		get {
			return createProvider(forTarget: Users.self)
		}
	}
	
	public var authentication: RxMoyaProvider<Authentication> {
		get {
			return createProvider(forTarget: Authentication.self)
		}
	}
	
	public var sync: RxMoyaProvider<Sync> {
		get {
			return createProvider(forTarget: Sync.self)
		}
	}
	
	public var shows: RxMoyaProvider<Shows> {
		get {
			return createProvider(forTarget: Shows.self)
		}
	}

	public var seasons: RxMoyaProvider<Seasons> {
		get {
			return createProvider(forTarget: Seasons.self)
		}
	}
	
	private func createProvider<T: TraktType>(forTarget target: T.Type) -> RxMoyaProvider<T> {
		let endpointClosure = createEndpointClosure(forTarget: target)
		
		return RxMoyaProvider<T>(endpointClosure: endpointClosure, plugins: self.plugins)
	}
	
	private func createEndpointClosure<T: TargetType>(forTarget: T.Type) -> MoyaProvider<T>.EndpointClosure {
		let endpointClosure = { (target: T) -> Endpoint<T> in
			var endpoint = MoyaProvider.defaultEndpointMapping(for: target)
			endpoint = endpoint.adding(newHTTPHeaderFields: [TraktV2.headerContentType: TraktV2.contentTypeJSON])
			endpoint = endpoint.adding(newHTTPHeaderFields: [TraktV2.headerTraktAPIKey: self.clientId])
			endpoint = endpoint.adding(newHTTPHeaderFields: [TraktV2.headerTraktAPIVersion: TraktV2.apiVersion])
			
			return endpoint
		}
		
		return endpointClosure
	}
	
}
