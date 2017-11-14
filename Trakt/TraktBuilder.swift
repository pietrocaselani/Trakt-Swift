import Moya

public final class TraktBuilder {
	public var clientId: String?
	public var clientSecret: String?
	public var redirectURL: String?
	public var plugins: [PluginType]?
	public var userDefaults: UserDefaults
	public var callbackQueue: DispatchQueue?
	public var dateProvier: DateProvider
	public var interceptors: [RequestInterceptor]?

	public typealias BuilderClosure = (TraktBuilder) -> Void

	public init(buildClosure: BuilderClosure) {
		userDefaults = UserDefaults.standard
		dateProvier = DefaultDateProvider()
		buildClosure(self)
	}
}
