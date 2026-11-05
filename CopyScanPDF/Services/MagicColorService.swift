import CoreImage
import CoreImage.CIFilterBuiltins

final class MagicColorService {
    func render(_ image: CIImage, mode: EnhancementMode) -> CIImage {
        switch mode {
        case .original:
            return image
        case .color:
            return renderColor(image)
        case .grayscale:
            return renderColor(image).applyingFilter("CIColorControls", parameters: [
                kCIInputSaturationKey: 0
            ])
        case .blackAndWhite:
            let grayscale = renderColor(image).applyingFilter("CIColorControls", parameters: [
                kCIInputSaturationKey: 0,
                kCIInputContrastKey: 1.2
            ])
            return grayscale.applyingFilter("CIExposureAdjust", parameters: [kCIInputEVKey: 0.15])
        }
    }

    private func renderColor(_ image: CIImage) -> CIImage {
        let noiseReduction = image.applyingFilter("CINoiseReduction", parameters: [
            "inputNoiseLevel": 0.02,
            "inputSharpness": 0.4
        ])
        let exposure = noiseReduction.applyingFilter("CIExposureAdjust", parameters: [kCIInputEVKey: 0.08])
        return exposure.applyingFilter("CIColorControls", parameters: [
            kCIInputContrastKey: 1.12,
            kCIInputSaturationKey: 1.04,
            kCIInputBrightnessKey: 0.02
        ])
    }
}
