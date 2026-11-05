import CoreGraphics
import Foundation

enum EnhancementMode: String, Codable, CaseIterable, Identifiable {
    case original
    case color
    case grayscale
    case blackAndWhite

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .original: return "Gốc"
        case .color: return "Màu sắc"
        case .grayscale: return "Xám"
        case .blackAndWhite: return "Đen trắng"
        }
    }
}

struct CornerQuad: Codable, Equatable {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomRight: CGPoint
    var bottomLeft: CGPoint

    var points: [CGPoint] {
        [topLeft, topRight, bottomRight, bottomLeft]
    }

    static func normalized(
        topLeft: CGPoint = CGPoint(x: 0.1, y: 0.1),
        topRight: CGPoint = CGPoint(x: 0.9, y: 0.1),
        bottomRight: CGPoint = CGPoint(x: 0.9, y: 0.9),
        bottomLeft: CGPoint = CGPoint(x: 0.1, y: 0.9)
    ) -> CornerQuad {
        CornerQuad(
            topLeft: topLeft,
            topRight: topRight,
            bottomRight: bottomRight,
            bottomLeft: bottomLeft
        )
    }
}

struct OCRResult: Codable, Equatable {
    var recognizedText: String
    var languageCodes: [String]
    var confidence: Double?
    var recognizedAt: Date
}

struct ScannedPage: Codable, Identifiable, Equatable {
    let id: UUID
    var originalImagePath: String
    var processedImagePath: String?
    var cornerQuad: CornerQuad?
    var rotation: Int
    var enhancementMode: EnhancementMode
    var ocrResult: OCRResult?

    init(
        id: UUID = UUID(),
        originalImagePath: String,
        processedImagePath: String? = nil,
        cornerQuad: CornerQuad? = nil,
        rotation: Int = 0,
        enhancementMode: EnhancementMode = .color,
        ocrResult: OCRResult? = nil
    ) {
        self.id = id
        self.originalImagePath = originalImagePath
        self.processedImagePath = processedImagePath
        self.cornerQuad = cornerQuad
        self.rotation = rotation
        self.enhancementMode = enhancementMode
        self.ocrResult = ocrResult
    }
}

struct ExportSettings: Codable, Equatable {
    var pageSize: String = "A4"
    var dpi: Int = 300
    var jpegQuality: CGFloat = 0.92
}

struct ScanDocument: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var createdAt: Date
    var modifiedAt: Date
    var pages: [ScannedPage]
    var exportSettings: ExportSettings

    init(
        id: UUID = UUID(),
        title: String = "Tài liệu quét",
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        pages: [ScannedPage] = [],
        exportSettings: ExportSettings = ExportSettings()
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.pages = pages
        self.exportSettings = exportSettings
    }
}
