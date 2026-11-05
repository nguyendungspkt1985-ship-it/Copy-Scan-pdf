import PDFKit
import UIKit

final class PDFExportService {
    func export(document: ScanDocument, to url: URL) throws -> URL {
        let pdf = PDFDocument()

        for (index, page) in document.pages.enumerated() {
            let imageURL = URL(fileURLWithPath: page.processedImagePath ?? page.originalImagePath)
            guard let image = UIImage(contentsOfFile: imageURL.path) else {
                throw AppError.pdfExportFailed
            }
            let pageData = PDFPage(image: image)
            pageData?.setBounds(A4Geometry.pageSize.pdfRect, for: .mediaBox)
            if let pageData {
                pdf.insert(pageData, at: index)
            }
        }

        guard pdf.pageCount == document.pages.count,
              let pdfData = pdf.dataRepresentation() else {
            throw AppError.pdfExportFailed
        }
        try pdfData.write(to: url, options: .atomic)
        return url
    }
}

private extension CGSize {
    var pdfRect: CGRect {
        CGRect(origin: .zero, size: self)
    }
}
