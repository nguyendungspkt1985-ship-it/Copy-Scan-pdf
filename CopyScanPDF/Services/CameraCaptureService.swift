import AVFoundation
import Photos
import UIKit

enum CameraAuthorizationStatus {
    case authorized
    case denied
    case notDetermined
}

final class CameraCaptureService {
    func authorizationStatus() -> CameraAuthorizationStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .denied
        }
    }

    func requestAuthorization() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }

    func loadAuthorization() -> Bool {
        PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized ||
        PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited
    }
}
