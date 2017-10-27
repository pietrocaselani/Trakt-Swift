import XCTest
import Moya
import Moya_ObjectMapper
import RxTest
import RxSwift
import Trakt

final class ShowsTest: XCTestCase {
  private let showsProvider = RxMoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
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
    let disposable = showsProvider.request(target)
      .mapObject(Show.self)
      .subscribe(showObserver)

    scheduler.scheduleAt(500) {
      disposable.dispose()
    }

    scheduler.start()

    let expectedShow = try! Show(JSON: toObject(data: target.sampleData))

    let expectedEvents: [Recorded<Event<Show>>] = [next(0, expectedShow), completed(0)]

    XCTAssertEqual(showObserver.events, expectedEvents)
  }

}
