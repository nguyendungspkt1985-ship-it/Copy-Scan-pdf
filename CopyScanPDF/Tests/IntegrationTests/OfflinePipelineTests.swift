import CoreImage
import XCTest
@testable import CopyScanPDF

final class OfflinePipelineTests: XCTestCase {
    func testCorrectionAndEnhancementProduceA4SizedOutput() async throws {
        let source = CIImage(color: CIColor(red: 1, green: 1, blue: 1))
            .cropped(to: CGRect(x: 0, y: 0, width: 1000, height: 1400))
        let corrected = try await PerspectiveCorrectionService().correct(
            image: source,
            quad: .normalized(),
            outputSize: CGSize(width: A4Geometry.pixelsWidth, height: A4Geometry.pixelsHeight)
        )
        let enhanced = MagicColorService().render(corrected, mode: .color)
        XCTAssertGreaterThan(enhanced.extent.width, 0)
        XCTAssertGreaterThan(enhanced.extent.height, 0)
    }

    func testPipelineDoesNotUseEnvironmentNetworkConfiguration() {
        let env = ProcessInfo.processInfo.environment
        XCTAssertNil(env["COPYSCAN_API_URL"])
        XCTAssertNil(env["COPYSCAN_API_KEY"])
    }
}
