import XCTest
import Moya
import RxTest
import RxSwift
import TraktSwift

final class ShowsTest: XCTestCase {
  private let showsProvider = MoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  private let scheduler = TestScheduler(initialClock: 0)
  private var showObserver: TestableObserver<Show>!

  override func setUp() {
    super.setUp()

    showObserver = scheduler.createObserver(Show.self)
  }

  override func tearDown() {
    super.tearDown()

    showObserver = nil
  }

  func testShows_requestSummaryForAShow_parseToModels() {
    let target = Shows.summary(showId: "game-of-thrones", extended: .fullEpisodes)
    let disposable = showsProvider.rx.request(target)
        .map(Show.self)
        .asObservable()
        .subscribe(showObserver)

    scheduler.scheduleAt(500) {
      disposable.dispose()
    }

    scheduler.start()

    guard let expectedShow = try? JSONDecoder().decode(Show.self, from: target.sampleData) else {
      fatalError("Unable to parse JSON")
    }

    let expectedEvents: [Recorded<Event<Show>>] = [next(0, expectedShow), completed(0)]

    XCTAssertEqual(showObserver.events, expectedEvents)
  }

}
