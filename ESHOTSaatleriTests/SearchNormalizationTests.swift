import XCTest
@testable import ESHOTSaatleri

final class SearchNormalizationTests: XCTestCase {
    func testTurkishNormalization() {
        XCTAssertEqual("Çiğli İstasyon".normalizedForSearch, "cigli istasyon")
        XCTAssertTrue("Şirinyer".normalizedForSearch.contains("sirin"))
    }
}
