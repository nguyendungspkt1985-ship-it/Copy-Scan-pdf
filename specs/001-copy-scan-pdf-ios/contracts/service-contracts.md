# Hợp đồng dịch vụ nội bộ

Các hợp đồng này mô tả API logic giữa UI và service, không phải API mạng.

## CameraCaptureService

```swift
func capturePhoto() async throws -> Data
func authorizationStatus() -> CameraAuthorizationStatus
```

## DocumentDetectionService

```swift
func detectCorners(in image: CIImage) async throws -> CornerQuad?
```

## PerspectiveCorrectionService

```swift
func correct(image: CIImage, quad: CornerQuad, outputSize: CGSize) async throws -> CIImage
```

## MagicColorService

```swift
func render(image: CIImage, mode: EnhancementMode) async throws -> CIImage
```

## OCRService

```swift
func recognize(image: CIImage, languages: [String]) async throws -> OCRResult
```

## PDFExportService

```swift
func export(document: ScanDocument, outputURL: URL) async throws -> PDFExportArtifact
```

## Quy tắc lỗi

Mọi service phải trả về lỗi có mã, thông điệp có thể hiển thị và hành động khắc phục. Không log ảnh hoặc văn bản OCR.
