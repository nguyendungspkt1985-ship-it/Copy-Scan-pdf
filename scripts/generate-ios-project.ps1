$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..\CopyScanPDF")

if (-not (Get-Command xcodegen -ErrorAction SilentlyContinue)) {
    Write-Error "Cần chạy trên macOS và cài XcodeGen: brew install xcodegen"
}

xcodegen generate
Write-Host "Đã tạo CopyScanPDF.xcodeproj"
