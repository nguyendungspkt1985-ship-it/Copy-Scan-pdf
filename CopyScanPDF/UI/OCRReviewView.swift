import SwiftUI
import UIKit

struct OCRReviewView: View {
    let result: OCRResult?

    var body: some View {
        VStack(alignment: .leading) {
            if let result {
                ScrollView {
                    Text(result.recognizedText)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button("Sao chép") {
                    UIPasteboard.general.string = result.recognizedText
                }
                .buttonStyle(.borderedProminent)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "text.viewfinder")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Chưa có OCR")
                }
            }
        }
        .padding()
        .navigationTitle("Văn bản OCR")
    }
}
