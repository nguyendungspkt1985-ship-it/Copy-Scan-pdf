import CoreImage
import Vision

final class DocumentDetectionService {
    func detectCorners(in image: CIImage) async throws -> CornerQuad {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectRectanglesRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let observation = request.results?
                    .compactMap({ $0 as? VNRectangleObservation })
                    .max(by: { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height }),
                    observation.confidence >= 0.25 else {
                    continuation.resume(throwing: AppError.noDocumentCorners)
                    return
                }

                continuation.resume(returning: CornerQuad(
                    topLeft: observation.topLeft.toImagePoint(),
                    topRight: observation.topRight.toImagePoint(),
                    bottomRight: observation.bottomRight.toImagePoint(),
                    bottomLeft: observation.bottomLeft.toImagePoint()
                ))
            }
            request.maximumObservations = 8
            request.minimumAspectRatio = 0.2
            request.maximumAspectRatio = 2.0
            request.minimumConfidence = 0.25

            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

private extension CGPoint {
    func toImagePoint() -> CGPoint {
        CGPoint(x: x, y: 1 - y)
    }
}
