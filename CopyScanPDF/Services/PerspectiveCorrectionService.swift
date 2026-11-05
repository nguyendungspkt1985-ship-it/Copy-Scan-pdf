import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation

final class PerspectiveCorrectionService {
    func correct(image: CIImage, quad: CornerQuad, outputSize: CGSize = A4Geometry.pageSize.scaledFor300DPI) async throws -> CIImage {
        let transform: [String: Any] = [
            "inputTopLeft": quad.topLeft,
            "inputTopRight": quad.topRight,
            "inputBottomRight": quad.bottomRight,
            "inputBottomLeft": quad.bottomLeft
        ]

        let correction = CIFilter(name: "CIPerspectiveCorrection", parameters: transform)
        correction?.setValue(image, forKey: kCIInputImageKey)
        guard let output = correction?.outputImage else {
            throw AppError.imageEncodingFailed
        }

        let scaleX = outputSize.width / max(output.extent.width, 1)
        let scaleY = outputSize.height / max(output.extent.height, 1)
        return output.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}

private extension CGSize {
    var scaledFor300DPI: CGSize {
        CGSize(width: A4Geometry.pixelsWidth, height: A4Geometry.pixelsHeight)
    }
}
