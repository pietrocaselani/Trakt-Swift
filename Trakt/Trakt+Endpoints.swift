import Moya

extension Trakt {
  public var movies: RxMoyaProvider<Movies> {
    return createProvider(forTarget: Movies.self)
  }

  public var genres: RxMoyaProvider<Genres> {
    return createProvider(forTarget: Genres.self)
  }

  public var search: RxMoyaProvider<Search> {
    return createProvider(forTarget: Search.self)
  }

  public var shows: RxMoyaProvider<Shows> {
    return createProvider(forTarget: Shows.self)
  }

  public var users: RxMoyaProvider<Users> {
    return createProvider(forTarget: Users.self)
  }

  public var authentication: RxMoyaProvider<Authentication> {
    return createProvider(forTarget: Authentication.self)
  }

  public var sync: RxMoyaProvider<Sync> {
    return createProvider(forTarget: Sync.self)
  }

  public var episodes: RxMoyaProvider<Episodes> {
    return createProvider(forTarget: Episodes.self)
  }

  private func createProvider<T: TraktType>(forTarget target: T.Type) -> RxMoyaProvider<T> {
    let endpointClosure = createEndpointClosure(forTarget: target)

    return RxMoyaProvider<T>(endpointClosure: endpointClosure, plugins: plugins)
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
