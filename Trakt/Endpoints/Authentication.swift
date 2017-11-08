import Moya

public enum Authentication {
  case accessToken(code: String, clientId: String, clientSecret: String, redirectURL: String, grantType: String)
}

extension Authentication: TraktType {
  public var path: String {
    return Trakt.OAuth2TokenPath
  }

  public var method: Moya.Method { return .post }

  public var task: Task {
    switch self {
    case .accessToken(let code, let clientId, let clientSecret, let redirectURL, let grantType):
      let parameters = ["code": code,
                        "client_id": clientId,
                        "client_secret": clientSecret,
                        "redirect_uri": redirectURL,
                        "grant_type": grantType]
      return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
  }

	public var sampleData: Data {
		switch self {
		case .accessToken(let code, _, _, _, _):
			if code == "my_wrong_code" {
				return stubbedResponse("trakt_authentication_accesstoken_wrong")
			}
			return stubbedResponse("trakt_authentication_accesstoken")
		}
	}
}
