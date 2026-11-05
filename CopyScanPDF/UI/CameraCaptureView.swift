import PhotosUI
import SwiftUI

struct CameraCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "doc.viewfinder")
                    .font(.system(size: 72))
                    .foregroundStyle(.blue)

                Text("Chụp tài liệu hoặc chọn ảnh có sẵn")
                    .font(.headline)

                PhotosPicker("Chọn ảnh", selection: $selectedItem, matching: .images)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Quét trang mới")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
            .onChange(of: selectedItem) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    } else {
                        errorMessage = AppError.imageEncodingFailed.localizedDescription
                    }
                }
            }
            .fullScreenCover(item: Binding(
                get: { selectedImage.map(SelectedImageContainer.init) },
                set: { _ in selectedImage = nil }
            )) { image in
                DocumentEditorView(image: image.image)
            }
            .alert("Lỗi", isPresented: .constant(errorMessage != nil)) {
                Button("Đóng") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
}

private struct SelectedImageContainer: Identifiable {
    let id = UUID()
    let image: UIImage
}
