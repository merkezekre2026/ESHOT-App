import Foundation

protocol DatasetCaching {
    func save(data: Data, key: String) throws
    func loadData(for key: String) throws -> Data?
    func lastModified(for key: String) -> Date?
}

struct FileDatasetCache: DatasetCaching {
    private let manager = FileManager.default

    private var cacheDir: URL {
        manager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ESHOTSaatleri", isDirectory: true)
    }

    func save(data: Data, key: String) throws {
        if !manager.fileExists(atPath: cacheDir.path) {
            try manager.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        }
        try data.write(to: cacheDir.appendingPathComponent(key), options: .atomic)
    }

    func loadData(for key: String) throws -> Data? {
        let url = cacheDir.appendingPathComponent(key)
        guard manager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    func lastModified(for key: String) -> Date? {
        let path = cacheDir.appendingPathComponent(key).path
        guard let attrs = try? manager.attributesOfItem(atPath: path) else { return nil }
        return attrs[.modificationDate] as? Date
    }
}
