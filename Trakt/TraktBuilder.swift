import Moya

public final class TraktBuilder {
	public var clientId: String?
	public var clientSecret: String?
	public var redirectURL: String?
	public var plugins: [PluginType]?
	public var userDefaults: UserDefaults?
	public var callbackQueue: DispatchQueue?

	public typealias BuilderClosure = (TraktBuilder) -> Void

	public init(buildClosure: BuilderClosure) {
		userDefaults = UserDefaults.standard
		buildClosure(self)
	}
}
