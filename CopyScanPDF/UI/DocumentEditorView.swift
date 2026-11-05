import CoreImage
import SwiftUI
import UIKit

struct DocumentEditorView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var quad = CornerQuad.normalized()
    @State private var mode: EnhancementMode = .color
    @State private var isProcessing = false
    @State private var previewImage: UIImage?
    @State private var errorMessage: String?

    private let detector = DocumentDetectionService()
    private let correction = PerspectiveCorrectionService()
    private let enhancer = MagicColorService()

    var body: some View {
        NavigationStack {
            VStack {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 520)
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 520)
                }

                Picker("Chế độ màu", selection: $mode) {
                    ForEach(EnhancementMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Button(isProcessing ? "Đang xử lý…" : "Lưu trang") {
                    Task { await savePage() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isProcessing)
            }
            .navigationTitle("Chỉnh trang")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Làm mới preview") {
                        Task { await updatePreview() }
                    }
                }
            }
            .task {
                await detectCorners()
            }
            .alert("Lỗi", isPresented: .constant(errorMessage != nil)) {
                Button("Đóng") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func detectCorners() async {
        guard let ciImage = CIImage(image: image) else { return }
        do {
            quad = try await detector.detectCorners(in: ciImage)
        } catch {
            errorMessage = AppError.noDocumentCorners.localizedDescription
        }
        await updatePreview()
    }

    private func updatePreview() async {
        guard let ciImage = CIImage(image: image) else { return }
        isProcessing = true
        defer { isProcessing = false }
        do {
            let corrected = try await correction.correct(image: ciImage, quad: quad)
            let enhanced = enhancer.render(corrected, mode: mode)
            previewImage = UIImage(ciImage: enhanced)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func savePage() async {
        guard let ciImage = CIImage(image: image),
              let encoded = try? await correction.correct(image: ciImage, quad: quad),
              let data = ImageCodec.jpegData(enhancer.render(encoded, mode: mode), quality: 0.92) else {
            errorMessage = AppError.imageEncodingFailed.localizedDescription
            return
        }

        let documentID = UUID()
        guard let store = try? DocumentStore() else {
            errorMessage = AppError.persistenceFailed.localizedDescription
            return
        }
        let url = store.makeImageURL(for: documentID, pageID: UUID())
        do {
            try data.write(to: url, options: Data.WritingOptions.atomic)
            try store.save(ScanDocument(id: documentID, pages: [
                ScannedPage(originalImagePath: url.path, processedImagePath: url.path, cornerQuad: quad, enhancementMode: mode)
            ]))
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
