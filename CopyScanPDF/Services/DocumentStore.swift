import Foundation

final class DocumentStore {
    private let documentsDirectory: URL
    private let fileManager = FileManager.default

    init() throws {
        let documents = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        documentsDirectory = documents.appendingPathComponent("CopyScanPDF", isDirectory: true)
        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
    }

    func save(_ document: ScanDocument) throws {
        let data = try JSONEncoder().encode(document)
        let url = documentsDirectory.appendingPathComponent("\(document.id.uuidString).json")
        try data.write(to: url, options: .atomic)
    }

    func loadDocuments() throws -> [ScanDocument] {
        let urls = try fileManager.contentsOfDirectory(
            at: documentsDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )
        return try urls.filter { $0.pathExtension == "json" }.map {
            let data = try Data(contentsOf: $0)
            return try JSONDecoder().decode(ScanDocument.self, from: data)
        }.sorted { $0.modifiedAt > $1.modifiedAt }
    }

    func makeImageURL(for documentID: UUID, pageID: UUID) -> URL {
        let folder = documentsDirectory.appendingPathComponent(documentID.uuidString, isDirectory: true)
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("\(pageID.uuidString).jpg")
    }
}
