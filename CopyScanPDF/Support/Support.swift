import CoreGraphics
import CoreImage

enum AppError: LocalizedError {
    case cameraUnavailable
    case cameraDenied
    case photoLibraryDenied
    case noDocumentCorners
    case imageEncodingFailed
    case insufficientStorage
    case ocrUnavailable
    case pdfExportFailed
    case persistenceFailed

    var errorDescription: String? {
        switch self {
        case .cameraUnavailable: return "Camera không khả dụng trên thiết bị này."
        case .cameraDenied: return "Ứng dụng chưa được phép truy cập Camera."
        case .photoLibraryDenied: return "Ứng dụng chưa được phép truy cập thư viện ảnh."
        case .noDocumentCorners: return "Không thể phát hiện đủ bốn góc tài liệu."
        case .imageEncodingFailed: return "Không thể mã hóa ảnh."
        case .insufficientStorage: return "Thiết bị không đủ dung lượng lưu trữ."
        case .ocrUnavailable: return "Ngôn ngữ OCR hiện không khả dụng."
        case .pdfExportFailed: return "Không thể tạo tệp PDF."
        case .persistenceFailed: return "Không thể lưu dữ liệu tài liệu."
        }
    }
}

enum A4Geometry {
    static let pointsWidth = 595.276
    static let pointsHeight = 841.890
    static let pixelsWidth = 2480
    static let pixelsHeight = 3508

    static let pageSize = CGSize(width: pointsWidth, height: pointsHeight)
}

enum ImageCodec {
    static func jpegData(_ image: CIImage, quality: CGFloat) -> Data? {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CIContext().jpegRepresentation(of: image, colorSpace: colorSpace, options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: quality]) else {
            return nil
        }
        return context
    }
}
