import SwiftUI

struct PageReviewView: View {
    @State var document: ScanDocument
    @State private var errorMessage: String?

    var body: some View {
        List {
            Section("Trang tài liệu") {
                ForEach(document.pages.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "\(index + 1).circle")
                        Text("Trang \(index + 1)")
                        Spacer()
                        Text(document.pages[index].enhancementMode.displayName)
                            .foregroundStyle(.secondary)
                    }
                }
                .onMove(perform: movePages)
                .onDelete(perform: deletePages)
            }

            Section {
                Button("Xuất PDF A4 300 DPI", action: exportPDF)
                    .disabled(document.pages.isEmpty)
                Button("OCR trang") {
                    Task { await runOCR() }
                }
                .disabled(document.pages.isEmpty)
            }
        }
        .navigationTitle(document.title)
        .toolbar { EditButton() }
        .alert("Lỗi", isPresented: .constant(errorMessage != nil)) {
            Button("Đóng") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func movePages(from source: IndexSet, to destination: Int) {
        document.pages.move(fromOffsets: source, toOffset: destination)
    }

    private func deletePages(at offsets: IndexSet) {
        document.pages.remove(atOffsets: offsets)
    }

    private func exportPDF() {
        do {
            let url = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("\(document.title).pdf")
            _ = try PDFExportService().export(document: document, to: url)
            errorMessage = "Đã tạo PDF tại: \(url.lastPathComponent)"
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func runOCR() async {
        let service = OCRService()
        let languages = ["vi-VN", "vi", "en-US", "en"].filter { service.supportedLanguages().contains($0) }
        guard let first = document.pages.first,
              let data = FileManager.default.contents(atPath: first.processedImagePath ?? first.originalImagePath),
              let image = UIImage(data: data),
              let ciImage = CIImage(image: image),
              !languages.isEmpty else {
            errorMessage = AppError.ocrUnavailable.localizedDescription
            return
        }
        do {
            document.pages[0].ocrResult = try await service.recognize(ciImage, languages: languages)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
