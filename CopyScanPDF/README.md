# Copy Scan PDF

Ứng dụng native iOS quét tài liệu offline cho iPhone 13 trở lên chạy iOS 16.

## Yêu cầu trên macOS

- macOS có Xcode mới nhất tương thích iOS 16.
- XcodeGen: `brew install xcodegen`.
- Máy Mac có thể kết nối AltServer trên Windows theo cấu hình cá nhân.

## Tạo project và chạy

```bash
cd "Copy Scan pdf"
xcodegen generate --spec CopyScanPDF/project.yml
open CopyScanPDF.xcodeproj
```

Trong Xcode chọn iPhone thật hoặc simulator, chọn scheme `CopyScanPDF`, kiểm tra Team signing rồi chạy.

## Kiểm thử

```bash
xcodebuild -project CopyScanPDF.xcodeproj \
  -scheme CopyScanPDF \
  -destination "platform=iOS Simulator,name=iPhone 13" \
  test
```

Chạy kiểm thử thiết bị thật và luồng offline trước khi ký bản sideload qua AltServer.

## GitHub Actions

Workflow `.github/workflows/ios.yml` chạy trên macOS runner, tạo project bằng XcodeGen, build và chạy XCTest trên simulator. Đây là cổng build thay thế khi máy Windows không có Xcode.

AltServer không chạy bên trong GitHub Actions. Để tạo bản IPA sideload:

1. Cấu hình signing với Apple ID cá nhân hoặc certificate phát triển trong GitHub Actions.
2. Cài đặt thiết bị/certificate bằng GitHub Secrets.
3. Archive bằng Team signing rồi tải IPA từ workflow artifact.
4. Trên Windows, mở AltServer và refresh ứng dụng trên iPhone qua Wi-Fi local.
