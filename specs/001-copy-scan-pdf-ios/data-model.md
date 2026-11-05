# Mô hình dữ liệu

## ScanDocument

- `id`: UUID
- `title`: String
- `createdAt`: Date
- `modifiedAt`: Date
- `pages`: [ScannedPage] theo thứ tự
- `exportSettings`: ExportSettings

## ScannedPage

- `id`: UUID
- `originalImagePath`: String trong application sandbox
- `processedImagePath`: String?
- `cornerQuad`: CornerQuad?
- `rotation`: 0, 90, 180 hoặc 270 độ
- `enhancementMode`: Original, Color, Grayscale, B&W
- `ocrResult`: OCRResult?

## CornerQuad

- `topLeft`, `topRight`, `bottomRight`, `bottomLeft`: normalized CGPoint trong không gian ảnh.

## OCRResult

- `recognizedText`: String
- `languageCodes`: [String]
- `confidence`: Double?
- `recognizedAt`: Date

## ExportSettings

- `pageSize`: A4
- `dpi`: 300
- `jpegQuality`: giá trị cần xác định bằng kiểm thử image quality/dung lượng.

## PDFExportArtifact

- `id`: UUID
- `documentId`: UUID
- `fileURL`: URL
- `pageCount`: Int
- `createdAt`: Date
