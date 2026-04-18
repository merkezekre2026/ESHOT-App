import SwiftUI
import SwiftData

@main
struct ESHOTSaatleriApp: App {
    @StateObject private var appContainer = AppContainer.bootstrap()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appContainer)
        }
        .modelContainer(appContainer.modelContainer)
    }
}
