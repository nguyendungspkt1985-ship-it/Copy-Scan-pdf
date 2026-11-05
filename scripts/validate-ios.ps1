$ErrorActionPreference = "Stop"

Write-Host "GitHub Actions là cổng build iOS cho dự án này."
Write-Host "Workflow: .github/workflows/ios.yml"
Write-Host "Runner macos-15 tạo project bằng XcodeGen, build và chạy XCTest trên simulator iPhone 13."
