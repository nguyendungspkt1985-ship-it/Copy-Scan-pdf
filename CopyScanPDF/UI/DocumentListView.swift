import SwiftUI

struct DocumentListView: View {
    @State private var documents: [ScanDocument] = []
    @State private var isPresentingScanner = false
    @State private var errorMessage: String?
    private let store = try? DocumentStore()

    var body: some View {
        NavigationStack {
            Group {
                if documents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("Chưa có tài liệu")
                            .font(.headline)
                        Text("Chạm nút + để quét trang đầu tiên.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List(documents) { document in
                        NavigationLink(document.title) {
                            PageReviewView(document: document)
                        }
                    }
                }
            }
            .navigationTitle("Copy Scan PDF")
            .toolbar {
                Button {
                    isPresentingScanner = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isPresentingScanner) {
                CameraCaptureView()
            }
            .alert("Không thể hoàn tất thao tác", isPresented: .constant(errorMessage != nil)) {
                Button("Đóng") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
            .task {
                loadDocuments()
            }
        }
    }

    private func loadDocuments() {
        do {
            documents = try store?.loadDocuments() ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
