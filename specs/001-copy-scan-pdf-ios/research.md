# Nghiên cứu kỹ thuật

## Quyết định

### Framework ứng dụng
- **Quyết định**: SwiftUI cho UI; AVFoundation cho camera; Foundation/FileManager cho lưu trữ.
- **Lý do**: Native iOS dễ tích hợp framework quyền, camera và Vision; phù hợp iOS 16 và AltServer.
- **Phương án thay thế bị loại**: React Native/Flutter vì tăng dependency và khó tối ưu pipeline native; Python runtime không phù hợp để đóng gói iOS native.

### Phát hiện biên và nắn phối cảnh
- **Quyết định**: Vision/Core Image xử lý phát hiện và nắn phối cảnh; cho phép chỉnh bốn góc thủ công.
- **Lý do**: Không cần dependency bên thứ ba và có thể kiểm thử bằng XCT.
- **Điểm cần xác minh thiết bị**: độ chính xác tối ưu cho ảnh A4 và nền phức tạp.

### Magic Color
- **Quyết định**: Core Image pipeline kết hợp correction, contrast, vignette/shadow suppression và chế độ B&W.
- **Lý do**: xử lý GPU/CPU native, preview không chỉnh ảnh gốc và không cần download model.
- **Đưa về quyết định thiết kế**: mọi preset phải hiển thị preview trước khi lưu.

### OCR
- **Quyết định**: Vision `VNRecognizeTextRequest` chạy local.
- **Lý do**: đáp ứng offline và native.
- **Ràng buộc cần kiểm chứng trên toolchain iOS 16**: danh sách ngôn ngữ hỗ trợ, độ chính xác tiếng Việt, trạng thái tiếng Việt trong recognitionLanguages và mức fallback theo phiên bản thiết bị/OS.

### PDF
- **Quyết định**: PDFKit tạo PDF vector wrapper trỏ tới trang ảnh A4; kích thước trang chuẩn 595.276 x 841.890 points tương ứng A4.
- **Quyết định độ phân giải**: xử lý và xuất ảnh với pixel dimension tương đương 2480 x 3508 pixels cho A4 ở 300 DPI.
- **Lý do**: đủ sắc nét cho tài liệu in và ổn định kích thước trang.

### Triển khai cá nhân
- **Quyết định**: Xcode + Apple ID cá nhân và AltServer trên Windows; tài liệu gia hạn Wi-Fi phải rõ ràng trong Quickstart.
- **Ràng buộc**: giới hạn Bundle ID/capability/chu kỳ ký phụ thuộc bản Xcode và chính sách Apple hiện hành.
