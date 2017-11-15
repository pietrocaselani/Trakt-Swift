import XCTest
import Moya
import RxTest
import RxSwift
@testable import TraktSwift

final class TraktTests: XCTestCase {
	private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
	private var authorizeURL: URL!
	private let clientId = "my_awesome_client_id"
	private let clientSecret = "my_awesome_client_secret"
	private let redirectURL = "couchtracker://my_awesome_url"
	private let redirectURLValid = "couchtracker://my_awesome_url?code=my_awesome_code"
	private let redirectURLWrongCode = "couchtracker://my_awesome_url?code=my_wrong_code"
	private let scheduler = TestScheduler(initialClock: 0)
	private var trakt: Trakt!
	private let beginOfTime = Date(timeIntervalSince1970: 0)

	override func setUp() {
		let link = "https://trakt.tv/oauth/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectURL)"
		authorizeURL = URL(string: link)!
		clearUserDefaults(userDefaultsMock)
		super.setUp()
	}

	private func clearUserDefaults(_ userDefaults: UserDefaults) {
		for (key, _) in userDefaults.dictionaryRepresentation() {
			userDefaults.removeObject(forKey: key)
		}
	}

	private func setupTrakt() {
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.userDefaults = userDefaultsMock
			$0.dateProvider = TestableDateProvider(now: beginOfTime)
		}

		trakt = Trakt(builder: builder)
	}

	private func setupTraktForAuthentication(_ token: Token? = nil) {
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.clientSecret = clientSecret
			$0.redirectURL = redirectURL
			$0.userDefaults = userDefaultsMock
			$0.dateProvider = TestableDateProvider(now: beginOfTime)
		}

		trakt = Trakt(builder: builder)
		trakt.accessToken = token
	}

	func testTrakt_cantCreateInstanceWithoutClientId() {
		let builder = TraktBuilder {
			$0.clientId = nil
		}

		expectFatalError(expectedMessage: "Trakt needs a clientId") {
			_ = Trakt(builder: builder)
		}
	}

	func testTrakt_endpointsHasRequiredHeaders() {
		setupTrakt()
		let endpoint = trakt.movies.endpoint(.trending(page: 0, limit: 0, extended: .full))

		let expectedHeaders = [Trakt.headerTraktAPIVersion: "2",
		                       Trakt.headerTraktAPIKey: "my_awesome_client_id",
		                       Trakt.headerContentType: "application/json"]

		XCTAssertEqual(endpoint.httpHeaderFields!, expectedHeaders)
	}

	func testTrakt_receivesRedirectURL_createsOAuthURL() {
		//Given
		setupTraktForAuthentication()

		//When
		let url = trakt.oauthURL

		//Then
		let link = "https://trakt.tv/oauth/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectURL)"
		let expectedURL = URL(string: link)
		XCTAssertEqual(url, expectedURL)
	}

	func testTrakt_validateTokenExpirationDate() {
		//Given
		let token = Token(accessToken: "accesstokenMock", expiresIn: beginOfTime.timeIntervalSince1970 + 60 * 60 * 24,
		                  refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
		setupTraktForAuthentication(token)

		//When
		let isTokenValid = trakt.hasValidToken

		XCTAssertTrue(isTokenValid)
	}

	func testTrakt_invalidateTokenExpirationDate() {
		//Given
		let token = Token(accessToken: "accesstokenMock", expiresIn: beginOfTime.timeIntervalSince1970,
		                  refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
		setupTraktForAuthentication(token)

		//When
		let isTokenValid = trakt.hasValidToken

		XCTAssertFalse(isTokenValid)
	}

	func testTrakt_withAccessToken_addsAuthorizationHeader() {
		//Given
		let token = Token(accessToken: "accesstokenMock", expiresIn: Date().timeIntervalSince1970 + 3000,
		                  refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
		setupTraktForAuthentication(token)

		let responseExpectation = expectation(description: "Expect receives response")

		//When
		trakt.users.request(.settings) { result in
			if case .success(let response) = result {
				responseExpectation.fulfill()
				let authorizationValue = response.request?.allHTTPHeaderFields!["Authorization"]
				XCTAssertEqual(authorizationValue, "Bearer accesstokenMock")
			}
		}

		//Then
		wait(for: [responseExpectation], timeout: 5)
	}

	func testTrakt_withoutTraktSecret_authenticationFails() {
		//Given
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.redirectURL = redirectURLValid
			$0.userDefaults = userDefaultsMock
		}

		trakt = Trakt(builder: builder)
		let request = URLRequest(url: authorizeURL)
		let observer = scheduler.createObserver(AuthenticationResult.self)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe(observer)

		//Then
		let expectedError = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
		let expectedEvents: [Recorded<Event<AuthenticationResult>>] = [error(0, expectedError)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testTrakt_withoutRedirectURL_authenticationFails() {
		//Given
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.clientSecret = clientSecret
			$0.userDefaults = userDefaultsMock
		}

		trakt = Trakt(builder: builder)
		let request = URLRequest(url: authorizeURL)
		let observer = scheduler.createObserver(AuthenticationResult.self)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe(observer)

		//Then
		let expectedError = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
		let expectedEvents: [Recorded<Event<AuthenticationResult>>] = [error(0, expectedError)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testTrakt_forUnknownHost_emitsAuthenticationUndetermined() {
		//Given
		setupTraktForAuthentication()
		let request = URLRequest(url: authorizeURL)
		let observer = scheduler.createObserver(AuthenticationResult.self)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe(observer)

		//Then
		let expectedEvents = [next(0, AuthenticationResult.undetermined), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testTrakt_forURLWithoutCode_emitsAuthenticationUndetermined() {
		//Given
		setupTraktForAuthentication()
		let request = URLRequest(url: URL(string: redirectURL)!)
		let observer = scheduler.createObserver(AuthenticationResult.self)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe(observer)

		//Then
		let expectedEvents = [next(0, AuthenticationResult.undetermined), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testTrakt_forURLWithValidCode_shouldSaveToken() {
		//Given
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.clientSecret = clientSecret
			$0.redirectURL = redirectURL
			$0.userDefaults = userDefaultsMock
			$0.dateProvider = TestableDateProvider(now: beginOfTime)
		}

		let trakt = TestableTrakt(builder: builder)

		let request = URLRequest(url: URL(string: redirectURLValid)!)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe()

		//Then
		XCTAssertEqual(trakt.accessToken?.accessToken, "dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781")
		XCTAssertEqual(trakt.accessToken?.refreshToken, "76ba4c5c75c96f6087f58a4de10be6c00b29ea1ddc3b2022ee2016d1363e3a7c")

//		let tokenData = userDefaultsMock.object(forKey: Trakt.accessTokenKey) as? Data
//		if let tokenData = tokenData, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token {
//			XCTAssertEqual(token.accessToken, "dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781")
//			XCTAssertEqual(token.refreshToken, "76ba4c5c75c96f6087f58a4de10be6c00b29ea1ddc3b2022ee2016d1363e3a7c")
//		} else {
//			XCTFail("Invalid token")
//		}

		let newTrakt = TestableTrakt(builder: builder)
		XCTAssertEqual(newTrakt.accessToken?.accessToken, "dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781")
		XCTAssertEqual(newTrakt.accessToken?.refreshToken, "76ba4c5c75c96f6087f58a4de10be6c00b29ea1ddc3b2022ee2016d1363e3a7c")
	}

	func testTrakt_forURLWithValidCode_shouldAuthenticate() {
		//Given
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.clientSecret = clientSecret
			$0.redirectURL = redirectURL
			$0.userDefaults = userDefaultsMock
		}

		let trakt = TestableTrakt(builder: builder)

		let request = URLRequest(url: URL(string: redirectURLValid)!)
		let observer = scheduler.createObserver(AuthenticationResult.self)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe(observer)

		//Then
		let expectedEvents = [next(0, AuthenticationResult.authenticated), completed(0)]
		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testTrakt_invalidResponse_shouldEmitError() {
		//Given
		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.clientSecret = clientSecret
			$0.redirectURL = redirectURL
			$0.userDefaults = userDefaultsMock
		}

		let trakt = TestableTrakt(builder: builder)

		let request = URLRequest(url: URL(string: redirectURLWrongCode)!)
		let observer = scheduler.createObserver(AuthenticationResult.self)

		//When
		_ = trakt.finishesAuthentication(with: request).asObservable().subscribe(observer)

		//Then
		XCTAssertEqual(observer.events.count, 1)
	}
}
