# Copy Scan PDF Constitution

## Nguyên tắc cốt lõi

### I. Offline-first và quyền riêng tư
Mọi xử lý ảnh, OCR, PDF và dữ liệu người dùng phải diễn ra trên thiết bị. Không được gửi tài liệu hoặc metadata tới dịch vụ đám mây. Không thêm telemetry, analytics hoặc network dependency khi không có yêu cầu và phê duyệt riêng.

### II. Native iOS, ưu tiên framework của Apple
Ứng dụng được triển khai bằng Swift, SwiftUI và các framework native phù hợp cho iPhone 13 trở lên chạy iOS 16 trở lên. OCR sử dụng Vision Framework. Cải tiến biên và Magic Color có thể dùng Core Image, Accelerate và Vision, ưu tiên API có hỗ trợ thiết bị.

### III. Kiểm thử trước khi đóng gói (NON-NEGOTIABLE)
Mỗi thay đổi xử lý tài liệu phải có fixture đầu vào xác định, kiểm thử tự động và tiêu chí đầu ra có thể đo. Luồng chụp, crop, xoay, Magic Color, OCR, xuất PDF và chia sẻ phải có kiểm thử trên simulator trước; kiểm thử thiết bị thật trên iPhone cá nhân là cổng bắt buộc trước khi bàn giao.

### IV. Chất lượng tài liệu đạt cấp scanner cao cấp
Luồng xử lý tài liệu phải phát hiện và canh biên chính xác, nắn phối cảnh, loại bóng, khử nhiễu, tăng tương phản và hỗ trợ nhận diện trang A4. Magic Color phải có ít nhất chế độ Original, Color, Grayscale và B&W với preview trước khi lưu.

### V. Tính lặp lại, hiệu năng và đơn giản
Xử lý ảnh và PDF phải có API đồng nhất, state rời rạc và dữ liệu có thể tái kiểm chứng. Tránh phụ thuộc dịch vụ bên thứ ba; độ trễ UI không được chặn đáng kể bởi OCR hoặc xử lý ảnh. Phiên bản và migration được ghi rõ bằng semantic versioning.

## Ràng buộc kỹ thuật
- Target iPhone 13 trở lên và iOS 16 trở lên.
- Đầu ra PDF mặc định theo khổ A4.
- OCR chạy trên Apple Vision Framework, hoàn toàn trên thiết bị.
- Không yêu cầu tài khoản đám mây hoặc App Store để sử dụng bản cá nhân.
- Bản cài đặt trên thiết bị được ký và triển khai qua AltServer trên Windows.
- Gia hạn cài đặt qua mạng Wi-Fi local phải được mô tả và tự động hóa khi khả thi.
- Không lưu nhật ký nội dung tài liệu; dữ liệu tạm chỉ lưu trong application sandbox hoặc tệp người dùng chủ động tạo.

## Quy trình phát triển
- Mọi bước lớn phải đi qua cấu trúc Spec Kit: constitution, specify, clarify, plan, tasks, analyze và implement.
- Constitution phải được cập nhật khi quyết định kỹ thuật nền tảng thay đổi; mọi thay đổi constitution cần người dùng phê duyệt.
- Không bổ sung framework hoặc mã nguồn mở mới nếu framework native đã đáp ứng yêu cầu.
- Test fixture, kết quả mong đợi và hướng dẫn chạy thử phải đi kèm khi triển khai tính năng xử lý tài liệu.

## Governance
Constitution này là nguồn chuẩn cho mọi đặc tả, kế hoạch và task. Khi xung đột với tài liệu cũ, constitution và yêu cầu đã được người dùng xác nhận có ưu tiên cao hơn. Mọi thay đổi lớn cần ghi trong changelog của constitution, được kiểm tra nhất quán với spec, plan và tasks, và chờ người dùng duyệt.

**Phiên bản**: 1.0.0 | **Ban hành**: 2026-11-05 | **Sửa đổi gần nhất**: 2026-11-05
