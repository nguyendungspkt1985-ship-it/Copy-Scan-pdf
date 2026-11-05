import XCTest
@testable import CopyScanPDF

final class DocumentModelTests: XCTestCase {
    func testA4GeometryIs300DPI() {
        XCTAssertEqual(A4Geometry.pixelsWidth, 2480)
        XCTAssertEqual(A4Geometry.pixelsHeight, 3508)
    }

    func testQuadHasFourNormalizedPoints() {
        let quad = CornerQuad.normalized()
        XCTAssertEqual(quad.points.count, 4)
        XCTAssertTrue(quad.points.allSatisfy {
            $0.x >= 0 && $0.x <= 1 && $0.y >= 0 && $0.y <= 1
        })
    }

    func testDocumentPageOrder() {
        var document = ScanDocument(pages: [
            ScannedPage(originalImagePath: "1.jpg"),
            ScannedPage(originalImagePath: "2.jpg")
        ])
        document.pages.swapAt(0, 1)
        XCTAssertEqual(document.pages.map(\.originalImagePath), ["2.jpg", "1.jpg"])
    }

    func testDocumentRoundTripEncoding() throws {
        let document = ScanDocument(title: "Hợp đồng", pages: [
            ScannedPage(originalImagePath: "1.jpg", enhancementMode: .blackAndWhite)
        ])
        let data = try JSONEncoder().encode(document)
        let decoded = try JSONDecoder().decode(ScanDocument.self, from: data)
        XCTAssertEqual(decoded, document)
    }
}
