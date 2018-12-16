import XCTest
import Moya
import RxTest
import RxSwift
import TraktSwift

final class SeasonsTests: XCTestCase {
  private let seasonsProvider = MoyaProvider<Seasons>(stubClosure: MoyaProvider.immediatelyStub)
  private var scheduler: TestScheduler!

  override func setUp() {
    super.setUp()

    scheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()

    scheduler = nil
  }

  func testSeasons_requestSummaryforSeason_parseModels() {
    let target = Seasons.summary(showId: "the-100", exteded: .fullEpisodes)

    let res = scheduler.start {
      self.seasonsProvider.rx.request(target)
        .map([Season].self)
        .asObservable()
    }

    let expectedSeasons: [Season]

    do {
      expectedSeasons = try JSONDecoder().decode([Season].self, from: target.sampleData)
    } catch {
      Swift.fatalError("Unable to parse JSON: \(error)")
    }

    let expectedEvents = [next(200, expectedSeasons), completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }
}
