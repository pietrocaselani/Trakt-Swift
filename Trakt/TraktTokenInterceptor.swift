import Moya
import Result

final class TraktTokenInterceptor: RequestInterceptor {
	private weak var trakt: Trakt?

	init(trakt: Trakt) {
		self.trakt = trakt
	}

	func intercept<T>(endpoint: Endpoint<T>, done: @escaping MoyaProvider<T>.RequestResultClosure) where T: TraktType {
		guard let trakt = self.trakt else {
			done(.failure(MoyaError.requestMapping(endpoint.url)))
			return
		}

		guard let request = try? endpoint.urlRequest() else {
			done(.failure(MoyaError.requestMapping(endpoint.url)))
			return
		}

		if trakt.hasValidToken {
			done(.success(request))
			return
		}

		guard let currentToken = trakt.accessToken else {
			done(.failure(MoyaError.requestMapping(endpoint.url)))
			return
		}

		refreshToken(trakt, currentToken, request, Authentication.self, done)
	}

	private func refreshToken<T: TraktType>(_ trakt: Trakt,
	                                        _ token: Token,
	                                        _ request: URLRequest,
	                                        _ type: T.Type,
	                                        _ done: @escaping MoyaProvider<T>.RequestResultClosure) {
		guard let clientSecret = trakt.credentials.clientSecret else {
			done(.failure(MoyaError.requestMapping("Invalid client secret")))
			return
		}

		guard let redirectURL = trakt.credentials.redirectURL else {
			done(.failure(MoyaError.requestMapping("Invalid redirect url")))
			return
		}

		let target = Authentication.refreshToken(refreshToken: token.refreshToken,
		                                         clientId: trakt.credentials.clientId,
		                                         clientSecret: clientSecret,
		                                         redirectURL: redirectURL,
		                                         grantType: "refresh_token")

		trakt.authentication.request(target) { result in
			switch result {
			case .success(let response):
				do {
					let token = try response.filterSuccessfulStatusAndRedirectCodes().map(Token.self)
					trakt.accessToken = token
					done(.success(request))
				} catch {
					done(.failure(MoyaError.objectMapping(error, response)))
				}
			case .failure(let error):
				done(.failure(error))
			}
		}

	}
}
