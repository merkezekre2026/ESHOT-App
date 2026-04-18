import XCTest
@testable import ESHOTSaatleri

final class GTFSParserTests: XCTestCase {
    func testCSVParserReadsHeadersAndRows() throws {
        let parser = GTFSParser()
        let csv = "route_id,route_short_name,route_long_name\n1,10,F.Altay-Konak".data(using: .utf8)!
        let parsed = try parser.parseCSV(csv)

        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed.first?["route_short_name"], "10")
    }
}
