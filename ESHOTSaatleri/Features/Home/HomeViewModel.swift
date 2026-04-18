import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var query = ""
    @Published var recentItems: [String] = []

    func addRecent(_ value: String) {
        guard !value.isEmpty else { return }
        recentItems.removeAll(where: { $0 == value })
        recentItems.insert(value, at: 0)
        recentItems = Array(recentItems.prefix(8))
    }
}
