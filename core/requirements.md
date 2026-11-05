# Yêu cầu kỹ thuật - Copy Scan PDF Offline

## 1. Ràng buộc hệ thống
- Tuyệt đối không gọi API bên ngoài, không sử dụng các dịch vụ đám mây (Cloud API).
- Xử lý toàn bộ hình ảnh và tài liệu trực tiếp trong bộ nhớ cục bộ của thiết bị.

## 2. Module Xử lý hình ảnh cao cấp (CamScanner/CamPDF Standard)
- **Tự động bắt biên (Auto-Crop):** Nhận diện 4 góc tài liệu chính xác ngay cả trên nền phức tạp.
- **Nắn phẳng phối cảnh (Perspective Transform):** Biến đổi góc chụp nghiêng thành mặt phẳng vuông góc tiêu chuẩn.
- **Bộ lọc Magic Color:** Khử bóng tối do ánh sáng phòng, làm sạch nền thành trắng tinh khiết, tăng độ nét của chữ viết và con dấu mà không làm nhòe màu sắc quan trọng.

## 3. Module Nối trang & Xuất file
- Cho phép chụp liên tục nhiều trang, sắp xếp thứ tự và biên soạn thành một file PDF duy nhất với dung lượng tối ưu.