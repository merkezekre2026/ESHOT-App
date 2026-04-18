import Foundation

extension String {
    var normalizedForSearch: String {
        self
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "tr_TR"))
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "İ", with: "i")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
