import CoreImage
import Vision

final class OCRService {
    func supportedLanguages() -> [String] {
        let request = VNRecognizeTextRequest()
        let supported = (try? request.supportedRecognitionLanguages(for: .accurate, revision: VNRecognizeTextRequestRevision3)) ?? []
        let priority = ["vi-VN", "vi", "en-US", "en"]
        let others = supported.filter { !priority.contains($0) }
        return priority.filter { supported.contains($0) } + others
    }

    func recognize(_ image: CIImage, languages: [String]) async throws -> OCRResult {
        guard !supportedLanguages().isEmpty else { throw AppError.ocrUnavailable }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let observations = request.results?.compactMap { $0 as? VNRecognizedTextObservation } ?? []
                let candidates = observations.compactMap { $0.topCandidates(1).first }
                let text = candidates.map(\.string).joined(separator: "\n")
                let confidence = candidates.isEmpty ? nil : candidates.reduce(0) { $0 + $1.confidence } / Float(candidates.count)
                continuation.resume(returning: OCRResult(
                    recognizedText: text,
                    languageCodes: languages,
                    confidence: confidence.map(Double.init),
                    recognizedAt: Date()
                ))
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = languages.filter { supportedLanguages().contains($0) }

            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
