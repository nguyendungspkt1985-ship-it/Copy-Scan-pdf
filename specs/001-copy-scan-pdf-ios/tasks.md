# Tasks: Copy Scan PDF iOS offline

**Input**: `spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/`

## Phase 1: Setup

- [x] T001 Tạo project Xcode SwiftUI `CopyScanPDF` cho iOS 16 tại `CopyScanPDF/`
- [ ] T002 [P] Cấu hình Bundle ID, signing cá nhân, quyền Camera và Photo Library tại `CopyScanPDF/App/Info.plist`
- [x] T003 [P] Tạo cấu trúc thư mục App, Models, Services, UI và Tests theo plan
- [ ] T004 [P] Tạo test fixture A4, nền phức tạp, góc nghiêng, tiếng Việt và tiếng Anh tại `CopyScanPDF/Tests/Fixtures/`

## Phase 2: Foundational

**CRITICAL**: Chỉ bắt đầu user story sau khi foundation hoàn tất.

- [x] T005 Tạo các model core trong `CopyScanPDF/Models/`
- [ ] T006 [P] Tạo `AppError`, codec ảnh và geometry khổ A4 trong `CopyScanPDF/Support/`
- [ ] T007 [P] Tạo persistence sandbox và quản lý thư mục tài liệu trong `CopyScanPDF/Services/DocumentStore.swift`
- [ ] T008 [P] Thiết lập dependency container và điều hướng ứng dụng trong `CopyScanPDF/App/`
- [x] T009 Viết unit test cho `CornerQuad`, thứ tự trang, A4 geometry và serialization dữ liệu
- [ ] T010 [P] Bổ sung kiểm thử mạng: xác nhận không phát sinh network request khi chạy pipeline chính

**Checkpoint**: Foundation ready.

## Phase 3: User Story 1 - Quét trang (Priority P1) MVP

**Goal**: Chụp/chọn ảnh, crop, nắn phối cảnh và Magic Color.

**Independent Test**: Quét mẫu A4, sửa góc thủ công, chọn 4 chế độ màu và lưu trang.

- [ ] T011 Viết unit test phát hiện biên và crop trong `CopyScanPDF/Tests/UnitTests/DocumentDetectionTests.swift`
- [ ] T012 Viết integration test luồng capture → correction → enhancement tại `CopyScanPDF/Tests/IntegrationTests/PageScanTests.swift`
- [ ] T013 [P] [US1] Tạo `CameraCaptureService` bằng AVFoundation tại `CopyScanPDF/Services/CameraCaptureService.swift`
- [ ] T014 [P] [US1] Tạo `DocumentDetectionService` bằng Vision/Core Image tại `CopyScanPDF/Services/DocumentDetectionService.swift`
- [ ] T015 [US1] Tạo `PerspectiveCorrectionService` tại `CopyScanPDF/Services/PerspectiveCorrectionService.swift`
- [ ] T016 [US1] Tạo `MagicColorService` với Original, Color, Grayscale và B&W tại `CopyScanPDF/Services/MagicColorService.swift`
- [ ] T017 [US1] Tạo màn hình camera và chọn ảnh tại `CopyScanPDF/UI/CameraCaptureView.swift`
- [ ] T018 [US1] Tạo màn hình chỉnh góc và preview màu tại `CopyScanPDF/UI/DocumentEditorView.swift`
- [ ] T019 [US1] Nối service và persistence để lưu trang đã xác nhận tại `CopyScanPDF/UI/DocumentEditorView.swift`
- [ ] T020 [US1] Xử lý từ chối Camera/Photo Library, ảnh lỗi và không đủ dung lượng tại `CopyScanPDF/UI/`

**Checkpoint**: User Story 1 hoạt động độc lập và là MVP.

## Phase 4: User Story 2 - Ghép PDF A4 (Priority P2)

**Goal**: Quản lý trang và xuất PDF A4 300 DPI.

**Independent Test**: Tạo 10 trang, xoay/xóa/sắp xếp và export PDF.

- [ ] T021 Viết test PDF geometry, số trang, thứ tự và kích thước A4 tại `CopyScanPDF/Tests/UnitTests/PDFExportTests.swift`
- [ ] T022 Viết integration test document 10 trang tại `CopyScanPDF/Tests/IntegrationTests/DocumentExportTests.swift`
- [ ] T023 [P] [US2] Tạo màn hình danh sách tài liệu tại `CopyScanPDF/UI/DocumentListView.swift`
- [ ] T024 [P] [US2] Tạo màn hình xem, xoay và sắp xếp trang tại `CopyScanPDF/UI/PageReviewView.swift`
- [ ] T025 [US2] Tạo `PDFExportService` với PDFKit và kích thước A4 300 DPI tại `CopyScanPDF/Services/PDFExportService.swift`
- [ ] T026 [US2] Tích hợp native share sheet và lưu tệp vào Files tại `CopyScanPDF/UI/`
- [ ] T027 [US2] Kiểm tra thời gian export 10 trang trên iPhone 13

**Checkpoint**: User Stories 1 và 2 hoạt động độc lập.

## Phase 5: User Story 3 - OCR offline (Priority P3)

**Goal**: Nhận dạng đa ngôn ngữ bằng Vision và tìm kiếm văn bản.

**Independent Test**: OCR tài liệu tiếng Việt/tiếng Anh ở chế độ máy bay.

- [ ] T028 Viết OCR unit/integration test bằng fixture tiếng Việt và tiếng Anh tại `CopyScanPDF/Tests/IntegrationTests/OCRTests.swift`
- [ ] T029 [US3] Tạo `OCRService` bằng Vision tại `CopyScanPDF/Services/OCRService.swift`
- [ ] T030 [US3] Tạo cấu hình ngôn ngữ OCR mặc định và lựa chọn đa ngôn ngữ tại `CopyScanPDF/UI/OCRReviewView.swift`
- [ ] T031 [US3] Tích hợp sao chép, hiển thị và tìm kiếm văn bản nhận dạng tại `CopyScanPDF/UI/OCRReviewView.swift`
- [ ] T032 [US3] Xử lý OCR bất đồng bộ, hủy tác vụ và ngôn ngữ không hỗ trợ

**Checkpoint**: Cả ba user story hoàn chỉnh.

## Phase 6: Polish và bàn giao AltServer

- [ ] T033 [P] Chạy toàn bộ unit/UI tests trên simulator và sửa lỗi hồi quy qua GitHub Actions
- [ ] T034 [P] Thu thập thiết lập hiệu năng 300 DPI và benchmark iPhone 13
- [ ] T035 [P] Kiểm tra tài liệu không tạo network request và không log nội dung
- [ ] T036 Đóng gói signing và kiểm thử cài đặt qua AltServer trên Windows tại `docs/ALTServer_QUICKSTART.md`
- [ ] T037 Kiểm thử luồng chính offline trên iPhone cá nhân
- [ ] T038 [P] Hoàn thiện hướng dẫn build và gia hạn Wi-Fi trong `specs/001-copy-scan-pdf-ios/quickstart.md`

## Dependencies

- T001-T010 phải hoàn thành trước mọi user story.
- US1 không phụ thuộc US2/US3.
- US2 phụ thuộc lưu trữ và model trang từ foundation, có thể tích hợp US1 nhưng phải độc lập kiểm thử.
- US3 phụ thuộc trang đã xử lý nhưng có thể test riêng bằng fixture.
- T033-T037 phụ thuộc tất cả story được chọn.

## Parallel Opportunities

- T002, T003 và T004 có thể thực hiện cùng lúc sau T001.
- T006, T007 và T008 có thể thực hiện cùng lúc sau T005.
- Trong US1: T013, T014, T016 có thể thực hiện song song sau model foundation.
- Trong US2: T023 và T024 có thể thực hiện song song.
- T033-T035 và T038 có thể thực hiện song song.

## Implementation Strategy

1. Setup + foundation.
2. Hoàn thành US1 và dùng làm MVP.
3. Thêm US2 rồi US3.
4. Chạy toàn bộ test simulator, sau đó kiểm thử iPhone thật.
5. Tạo bản sideload qua AltServer và xác nhận gia hạn Wi-Fi theo quickstart.
