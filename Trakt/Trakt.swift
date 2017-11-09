import Moya
import RxSwift

public class Trakt {
	private let clientId: String
	private let clientSecret: String?
	private let redirectURL: String?
	private var plugins: [PluginType]
	private let userDefaults: UserDefaults
	private let callbackQueue: DispatchQueue?
	public let oauthURL: URL?
	public private(set) var accessToken: Token? {
		didSet {
			guard let token = accessToken else { return }
			saveToken(token)
		}
	}

	public var hasValidToken: Bool {
		return accessToken?.expiresIn.compare(Date()) == .orderedDescending
	}

	public lazy var movies: MoyaProvider<Movies> = createProvider(forTarget: Movies.self)
	public lazy var genres: MoyaProvider<Genres> = createProvider(forTarget: Genres.self)
	public lazy var search: MoyaProvider<Search> = createProvider(forTarget: Search.self)
	public lazy var shows: MoyaProvider<Shows> = createProvider(forTarget: Shows.self)
	public lazy var users: MoyaProvider<Users> = createProvider(forTarget: Users.self)
	public lazy var authentication: MoyaProvider<Authentication> = createProvider(forTarget: Authentication.self)
	public lazy var sync: MoyaProvider<Sync> = createProvider(forTarget: Sync.self)
	public lazy var episodes: MoyaProvider<Episodes> = createProvider(forTarget: Episodes.self)

	public init(builder: TraktBuilder) {
		guard let clientId = builder.clientId else {
			fatalError("Trakt needs a clientId")
		}

		guard let userDefaults = builder.userDefaults else {
			fatalError("Trakt needs an userDefaults")
		}

		self.clientId = clientId
		self.clientSecret = builder.clientSecret
		self.redirectURL = builder.redirectURL
		self.userDefaults = userDefaults
		self.plugins = builder.plugins ?? [PluginType]()
		self.callbackQueue = builder.callbackQueue

		if let redirectURL = redirectURL {
			let url = Trakt.siteURL.appendingPathComponent(Trakt.OAuth2AuthorizationPath)
			var componenets = URLComponents(url: url, resolvingAgainstBaseURL: false)

			let responseTypeItem = URLQueryItem(name: "response_type", value: "code")
			let clientIdItem = URLQueryItem(name: "client_id", value: clientId)
			let redirectURIItem = URLQueryItem(name: "redirect_uri", value: redirectURL)
			componenets?.queryItems = [responseTypeItem, clientIdItem, redirectURIItem]

			self.oauthURL = componenets?.url
		} else {
			self.oauthURL = nil
		}

		loadToken()

		let accessTokenPlugin = AccessTokenPlugin(tokenClosure: { [unowned self] () -> String in
			return self.accessToken?.accessToken ?? ""
		}())

		plugins.append(accessTokenPlugin)
	}

	public func finishesAuthentication(with request: URLRequest) -> Single<AuthenticationResult> {
		guard let secret = clientSecret, let redirectURL = redirectURL else {
			let error = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
			return Single.error(error)
		}

		guard let url = request.url, let host = url.host, redirectURL.contains(host) else {
			return Single.just(AuthenticationResult.undetermined)
		}

		let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
		guard let codeItemValue = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
			return Single.just(AuthenticationResult.undetermined)
		}

		let target = Authentication.accessToken(code: codeItemValue, clientId: clientId, clientSecret: secret,
				redirectURL: redirectURL, grantType: "authorization_code")

		return self.authentication.rx.request(target)
				.filterSuccessfulStatusCodes()
				.flatMap { [unowned self] response -> Single<AuthenticationResult> in
					do {
						self.accessToken = try response.map(Token.self)
						return Single.just(AuthenticationResult.authenticated)
					} catch {
						return Single.error(error)
					}
				}
	}

	private func loadToken() {
		let tokenData = userDefaults.object(forKey: Trakt.accessTokenKey) as? Data
		if let tokenData = tokenData, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token {
			self.accessToken = token
		}
	}

	private func saveToken(_ token: Token) {
		let tokenData = NSKeyedArchiver.archivedData(withRootObject: token)
		userDefaults.set(tokenData, forKey: Trakt.accessTokenKey)
	}

	func createProvider<T: TraktType>(forTarget target: T.Type) -> MoyaProvider<T> {
		let endpointClosure = createEndpointClosure(forTarget: target)

		return MoyaProvider<T>(endpointClosure: endpointClosure, callbackQueue: self.callbackQueue, plugins: plugins)
	}

	private func createEndpointClosure<T: TargetType>(forTarget: T.Type) -> MoyaProvider<T>.EndpointClosure {
		let endpointClosure = { (target: T) -> Endpoint<T> in
			var endpoint = MoyaProvider.defaultEndpointMapping(for: target)
			endpoint = endpoint.adding(newHTTPHeaderFields: [Trakt.headerContentType: Trakt.contentTypeJSON])
			endpoint = endpoint.adding(newHTTPHeaderFields: [Trakt.headerTraktAPIKey: self.clientId])
			endpoint = endpoint.adding(newHTTPHeaderFields: [Trakt.headerTraktAPIVersion: Trakt.apiVersion])

			return endpoint
		}

		return endpointClosure
	}
}
