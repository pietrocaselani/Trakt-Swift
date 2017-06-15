//
//  TraktType.swift
//  Trakt
//
//  Created by Pietro Caselani on 21/01/17.
//  Copyright © 2017 Pietro Caselani. All rights reserved.
//

import Moya

public protocol TraktModel {}

public protocol TraktType: TargetType {}

public extension TraktType {

	public var baseURL: URL { return TraktV2.baseURL }
	
	public var method: Moya.Method { return .get }

	public var parameterEncoding: ParameterEncoding { return URLEncoding.default }

	public var task: Task { return .request }

}
