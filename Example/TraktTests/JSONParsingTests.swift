import XCTest
import RxTest
import RxSwift
@testable import TraktSwift

final class JSONParsingTests: XCTestCase {
	private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
	private let clientId = "my_awesome_client_id"
	private let clientSecret = "my_awesome_client_secret"
	private let redirectURL = "couchtracker://my_awesome_url"
	private let scheduler = TestScheduler(initialClock: 0)
	private var trakt: Trakt!

	override func setUp() {
		clearUserDefaults(userDefaultsMock)
		super.setUp()
	}

	private func clearUserDefaults(_ userDefaults: UserDefaults) {
		for (key, _) in userDefaults.dictionaryRepresentation() {
			userDefaults.removeObject(forKey: key)
		}
	}
	
	private func setupTraktForAuthentication(_ token: Token? = nil) {
		if let validToken = token {
			let data = NSKeyedArchiver.archivedData(withRootObject: validToken)
			userDefaultsMock.set(data, forKey: Trakt.accessTokenKey)
		}

		let builder = TraktBuilder {
			$0.clientId = clientId
			$0.clientSecret = clientSecret
			$0.redirectURL = redirectURL
			$0.userDefaults = userDefaultsMock
		}

		trakt = TestableTrakt(builder: builder)
	}
	
	func testParseSyncWatchedShows() {
		//Given
		let observer = scheduler.createObserver([BaseShow].self)
		let token = Token(accessToken: "accesstokenMock", expiresIn: Date().addingTimeInterval(3000),
		                  refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
		setupTraktForAuthentication(token)

		//Then
		_ = trakt.sync.rx.request(.watched(type: .shows, extended: .full)).map([BaseShow].self).asObservable().subscribe(observer)

		XCTAssertEqual(observer.events.count, 2)
		let next = observer.events.first!
		XCTAssertEqual(next.value.element!.count, 105)
	}
}
