# Đặc tả tính năng: Copy Scan PDF iOS offline

**Nhánh feature**: `001-copy-scan-pdf-ios`

**Ngày tạo**: 2026-11-05

**Trạng thái**: Draft

**Đầu vào**: Ứng dụng quét tài liệu PDF native cho iPhone 13 trở lên chạy iOS 16 trở lên, xử lý hoàn toàn offline với camera, phát hiện biên, nắn phối cảnh, Magic Color, OCR Apple Vision, ghép trang A4 và xuất PDF để sử dụng cá nhân qua AltServer.

## Kịch bản người dùng và kiểm thử

### User Story 1 - Quét tài liệu thành trang sắc nét (Priority: P1)

Người dùng chụp tài liệu bằng camera, xem khung tài liệu được phát hiện tự động, điều chỉnh bốn góc nếu cần, nắn phối cảnh và lưu thành trang quét. Ứng dụng áp dụng chế độ hình ảnh phù hợp và hiển thị preview trước khi xác nhận.

**Lý do ưu tiên**: Đây là luồng tạo trang quét nền tảng và cung cấp giá trị độc lập ngay cả khi chưa có OCR hay ghép PDF.

**Kiểm thử độc lập**: Quét tài liệu có nền đơn giản, nền phức tạp và góc chụp nghiêng; kiểm tra trang đầu ra được căn đúng và có thể sửa lại.

**Kịch bản chấp nhận**:

1. **Given** camera có quyền truy cập, **When** người dùng chụp tài liệu A4, **Then** hệ thống phát hiện biên hoặc cho phép chọn thủ công bốn góc.
2. **Given** bốn góc đã xác định, **When** người dùng xác nhận, **Then** ứng dụng nắn phối cảnh và tạo preview trang A4.
3. **Given** trang đang được preview, **When** người dùng áp dụng chế độ hình ảnh, **Then** preview cập nhật mà không thay đổi ảnh gốc trong phiên làm việc.

### User Story 2 - Ghép nhiều trang thành PDF A4 (Priority: P2)

Người dùng quét nhiều trang trong một tài liệu, sắp xếp, xoay hoặc xóa trang, sau đó xuất PDF theo khổ A4 để mở và chia sẻ trong Files.

**Lý do ưu tiên**: Ghép trang là nhu cầu chính của ứng dụng quét tài liệu sau luồng quét trang đơn.

**Kiểm thử độc lập**: Tạo tài liệu gồm ít nhất 10 trang, thay đổi thứ tự, xoay một trang và xuất PDF; kiểm tra số trang và hướng trang.

**Kịch bản chấp nhận**:

1. **Given** tài liệu có nhiều trang, **When** người dùng thay đổi thứ tự, **Then** PDF đầu ra giữ đúng thứ tự mới.
2. **Given** người dùng đã chọn trang, **When** yêu cầu xuất PDF, **Then** tệp PDF được tạo với kích thước trang A4.

### User Story 3 - Nhận dạng chữ và tìm kiếm offline (Priority: P3)

Người dùng yêu cầu OCR trang đã quét bằng Vision Framework và xem hoặc sao chép văn bản nhận dạng mà không cần kết nối internet.

**Lý do ưu tiên**: OCR tăng giá trị tài liệu quét nhưng không phải điều kiện bắt buộc để tạo PDF.

**Kiểm thử độc lập**: OCR trang tiếng Việt và tiếng Anh rõ nét trong chế độ máy bay; kiểm tra văn bản được hiển thị và không có request mạng.

**Kịch bản chấp nhận**:

1. **Given** trang có chữ rõ nét và thiết bị ở chế độ máy bay, **When** người dùng chạy OCR, **Then** ứng dụng trả về văn bản trên thiết bị.
2. **Given** OCR đã hoàn tất, **When** người dùng sao chép hoặc tìm kiếm văn bản, **Then** nội dung tương ứng được hiển thị chính xác.

## Edge Cases

- Ảnh mờ hoặc thiếu ánh sáng: cảnh báo người dùng, cho phép chụp lại hoặc tiếp tục thủ công.
- Không phát hiện đủ bốn góc: chuyển sang crop thủ công thay vì tạo trang sai.
- Trang không tách khỏi nền: người dùng có thể chọn bốn góc và xem preview.
- Không còn dung lượng lưu trữ: báo lỗi rõ ràng và không đánh mất tài liệu hiện có.
- Camera hoặc Photo Library bị từ chối: hướng dẫn cấp quyền mà không truy cập ngoài phạm vi.
- Ngôn ngữ OCR không được hỗ trợ: báo rõ ngôn ngữ không khả dụng.

## Yêu cầu chức năng

- **FR-001**: Hệ thống PHẢI cho phép chụp trang tài liệu qua camera hoặc chọn ảnh từ thư viện.
- **FR-002**: Hệ thống PHẢI phát hiện tự động bốn góc tài liệu khi biên có thể nhận diện.
- **FR-003**: Người dùng PHẢI có thể chỉnh thủ công bốn góc, xoay và sửa hình ảnh.
- **FR-004**: Hệ thống PHẢI nắn phối cảnh trang trước khi lưu.
- **FR-005**: Hệ thống PHẢI cung cấp chế độ Original, Color, Grayscale và B&W.
- **FR-006**: Magic Color PHẢI giảm bóng, tăng tương phản và giữ chi tiết chữ ở mức phù hợp để người dùng duyệt trước khi lưu.
- **FR-007**: Người dùng PHẢI có thể chụp liên tục nhiều trang trong một tài liệu.
- **FR-008**: Người dùng PHẢI có thể xem, xoay, xóa và sắp xếp lại trang.
- **FR-009**: Hệ thống PHẢI xuất PDF A4 với thứ tự trang đã chọn.
- **FR-010**: OCR PHẢI chạy hoàn toàn trên thiết bị bằng công nghệ nhận dạng trên thiết bị.
- **FR-011**: Hệ thống PHẢI cho phép xem, sao chép và tìm kiếm văn bản OCR.
- **FR-012**: Ứng dụng PHẢI hoạt động không cần internet trong toàn bộ luồng quét, xử lý, OCR và xuất PDF.
- **FR-013**: Dữ liệu tài liệu PHẢI chỉ lưu trong ứng dụng hoặc vị trí người dùng chủ động chọn.
- **FR-014**: Hệ thống PHẢI không thu thập telemetry, analytics hoặc nội dung tài liệu.
- **FR-015**: Ứng dụng PHẢI hỗ trợ iPhone 13 trở lên và iOS 16 trở lên.
- **FR-016**: PDF PHẢI có thể mở hoặc chia sẻ bằng luồng Files/native share sheet của thiết bị.
- **FR-017**: Người dùng PHẢI nhận thông báo lỗi có thể hành động nếu Camera bị từ chối, OCR thất bại hoặc lưu trữ không đủ.
- **FR-018**: Ảnh và trang PDF PHẢI được xuất ở chất lượng tương đương 300 DPI theo mặc định.
- **FR-019**: OCR PHẢI hỗ trợ nhiều ngôn ngữ trên thiết bị; bộ ngôn ngữ có thể chọn theo tài liệu và phải bao gồm tiếng Việt cùng tiếng Anh trong cấu hình mặc định.

## Thực thể chính

- **Phiên tài liệu**: Bộ trang, thứ tự, tên tài liệu, trạng thái xử lý và cấu hình xuất.
- **Trang quét**: Ảnh gốc, ảnh đã chỉnh, tọa độ bốn góc, góc xoay, chế độ màu và văn bản OCR.
- **Tệp PDF**: Tên, số trang, kích thước trang, URL lưu trữ và ngày tạo.

## Tiêu chí thành công

- **SC-001**: 90% tài liệu thử có trang A4 được phát hiện và crop đúng mà không sửa thủ công trong điều kiện ánh sáng tốt.
- **SC-002**: Người dùng hoàn thành quy trình quét, xem preview và lưu trang đơn trong vòng 30 giây sau lần mở đầu tiên.
- **SC-003**: Xuất PDF A4 10 trang trong vòng 10 giây trên iPhone 13 đại diện.
- **SC-004**: OCR mẫu tiếng Việt và tiếng Anh đạt ít nhất 95% ký tự đúng đối với tài liệu in rõ có độ phân giải tương đương 300 DPI.
- **SC-005**: Không phát sinh request mạng trong toàn bộ luồng quét, OCR và xuất PDF.
- **SC-006**: 95% phiên kiểm thử dừng an toàn và không làm mất trang khi Camera đóng hoặc hết dung lượng.

## Giả định

- Ứng dụng dành cho người dùng cá nhân, không yêu cầu tài khoản hoặc backend.
- Cài đặt iOS dùng bản sideload qua AltServer trên Windows.
- Magic Color hướng đến chất lượng cao cấp tương tự công cụ quét tài liệu chuyên dụng, nhưng người dùng vẫn có preview và lựa chọn chế độ.
- Ảnh được lưu tạm trong sandbox và không được gửi ra ngoài trừ khi người dùng chủ động chia sẻ.
