# Quickstart phát triển

## Môi trường Windows

1. Cài Xcode trên máy Mac.
2. Kết nối máy Mac với AltServer chạy trên Windows và đảm bảo iPhone cùng Wi-Fi LAN.
3. Đăng nhập Apple ID của người dùng trong Xcode nếu dùng sideload cá nhân.
4. Mở project Xcode sau khi project native được tạo ở giai đoạn implement.
5. Chọn iPhone cá nhân làm destination.
6. Build và chạy, sau đó cấp quyền Camera và Photo Library.

## Kiểm thử trước khi đóng gói

1. Chạy unit tests cho geometry, image enhancement và PDF geometry.
2. Chạy UI tests với dữ liệu A4 và ảnh đa nền.
3. Chạy OCR fixture ở chế độ máy bay.
4. Export PDF A4 10 trang và kiểm tra kích thước trang, số trang và thời gian xử lý trên iPhone 13.
5. Cài qua AltServer, tắt mạng Internet và chạy lại luồng chính.

## Gia hạn qua AltServer

- Đảm bảo AltServer chạy trong cùng Wi-Fi LAN với iPhone.
- Mở AltServer và cài/refresh ứng dụng qua máy tính.
- Gia hạn định kỳ theo giới hạn signing của Apple ID cá nhân.
- Không đưa workflow này vào ứng dụng và không yêu cầu quyền mạng cho tài liệu người dùng.

## GitHub Actions thay Xcode local trên Windows

1. Đẩy thay đổi lên GitHub để workflow `iOS build and tests` chạy trên macOS runner.
2. Tải artifact kết quả build/test.
3. Workflow không thể thay AltServer và không được dùng để ký bằng Apple ID cá nhân trong khi chưa cấu hình secret bảo mật.
4. Sau khi có IPA được ký hợp lệ, dùng AltServer trên Windows để cài và gia hạn qua Wi-Fi local.
