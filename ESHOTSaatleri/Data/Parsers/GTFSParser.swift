import Foundation

protocol GTFSParsing {
    func parseCSV(_ data: Data) throws -> [[String: String]]
}

struct GTFSParser: GTFSParsing {
    func parseCSV(_ data: Data) throws -> [[String: String]] {
        guard let text = String(data: data, encoding: .utf8) else {
            throw AppError.decodingError("CSV UTF-8 olarak okunamadı")
        }

        let lines = text.split(whereSeparator: \ .isNewline).map(String.init)
        guard let headerLine = lines.first else { return [] }
        let headers = splitCSVLine(headerLine)

        return lines.dropFirst().compactMap { line in
            let cols = splitCSVLine(line)
            guard cols.count == headers.count else { return nil }
            return Dictionary(uniqueKeysWithValues: zip(headers, cols))
        }
    }

    private func splitCSVLine(_ line: String) -> [String] {
        var result: [String] = []
        var current = ""
        var inQuotes = false

        for char in line {
            if char == "\"" {
                inQuotes.toggle()
                continue
            }
            if char == ",", !inQuotes {
                result.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }

        result.append(current)
        return result
    }
}
