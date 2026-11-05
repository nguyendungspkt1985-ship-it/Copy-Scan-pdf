# Kế hoạch triển khai: Copy Scan PDF iOS offline

**Nhánh**: `001-copy-scan-pdf-ios`
**Ngày**: 2026-11-05
**Đặc tả**: [spec.md](spec.md)

## Tóm tắt

Xây dựng ứng dụng quét tài liệu native bằng SwiftUI cho iPhone 13 trở lên, iOS 16 trở lên. Camera và quy trình chọn ảnh, phát hiện biên, nắn phối cảnh, Magic Color, OCR, quản lý trang và PDF được thực hiện hoàn toàn trên thiết bị. Pipeline ưu tiên framework của Apple; mã nguồn Python hiện có chỉ là prototype tham chiếu và không phải runtime của ứng dụng iOS.

## Ngữ cảnh kỹ thuật

- **Ngôn ngữ/phiên bản**: Swift 5.x; Deployment Target iOS 16.
- **Framework chính**: SwiftUI, AVFoundation, Vision, Core Image, Core Graphics, PDFKit.
- **Lưu trữ**: FileManager trong application sandbox; metadata có thể dùng JSON hoặc Core Data ở giai đoạn implementation.
- **Kiểm thử**: XCTest, Swift Testing nếu phù hợp với toolchain, image fixtures và kiểm thử iPhone thật.
- **Nền tảng**: iPhone 13 trở lên; AltServer trên Windows để ký sideload cá nhân.
- **Loại dự án**: Ứng dụng mobile native.
- **Mục tiêu hiệu năng**:
  - Preview crop/pipeline ảnh đáp ứng người dùng dưới 1 giây khi xử lý ảnh chụp tiêu chuẩn.
  - PDF A4 10 trang hoàn tất trong 10 giây trên iPhone 13 đại diện.
  - OCR chạy ở background, không khóa UI.
- **Ràng buộc**:
  - Không network access cho dữ liệu tài liệu.
  - PDF A4 mặc định và 300 DPI tương đương.
  - Không telemetry hoặc lưu nội dung tài liệu ngoài sandbox/trường hợp người dùng chủ động export.

## Kiểm tra Constitution

- Offline-first: đạt.
- Native Apple framework: đạt.
- Kiểm thử trước bàn giao: đạt.
- Chất lượng scanner cao cấp: đạt.
- Triển khai AltServer cá nhân: đạt.
- Không phát sinh dependency cloud: đạt.

## Kiến trúc logic

```text
App
├── UI
│   ├── CameraCaptureView
│   ├── DocumentEditorView
│   ├── PageReviewView
│   ├── OCRReviewView
│   └── DocumentListView
├── Services
│   ├── CameraCaptureService
│   ├── DocumentDetectionService
│   ├── PerspectiveCorrectionService
│   ├── MagicColorService
│   ├── OCRService
│   ├── PDFExportService
│   └── DocumentStore
├── Models
│   ├── ScanDocument
│   ├── ScannedPage
│   ├── CornerQuad
│   └── OCRResult
└── Support
    ├── ImageCodec
    ├── A4Geometry
    └── AppError
```

## Quy trình xử lý

1. Camera/Photo Library tạo `CIImage`.
2. Vision hoặc Core Image phân tích biên và trả về tứ giác.
3. Người dùng xác nhận hoặc chỉnh tứ giác.
4. Perspective correction chuẩn hóa trang theo khổ A4.
5. Magic Color render preview theo một trong các chế độ Original, Color, Grayscale, B&W.
6. Ảnh gốc và ảnh đã xử lý được lưu trong sandbox.
7. OCR thực thi bất đồng bộ và lưu kết quả nhận dạng theo trang.
8. PDFExportService tạo PDF A4 tương đương 300 DPI và cấp cho native share sheet.

## Cấu trúc dự án

```text
CopyScanPDF/
├── App/
├── Models/
├── Services/
├── UI/
├── Resources/
└── Tests/
    ├── Fixtures/
    ├── UnitTests/
    └── IntegrationTests/

specs/001-copy-scan-pdf-ios/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/
├── quickstart.md
└── tasks.md
```

## Theo dõi độ phức tạp

Không có vi phạm constitution cần miễn trừ. Không dùng backend, service network hoặc dependency runtime bên thứ ba trong bản đầu.
