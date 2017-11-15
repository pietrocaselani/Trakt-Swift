import Moya

public protocol RequestInterceptor {
	func intercept<T: TraktType>(endpoint: Endpoint<T>, done: @escaping MoyaProvider<T>.RequestResultClosure)
}
