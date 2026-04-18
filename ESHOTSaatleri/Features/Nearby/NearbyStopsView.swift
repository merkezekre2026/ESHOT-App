import SwiftUI

struct NearbyStopsView: View {
    @StateObject var viewModel: NearbyStopsViewModel

    var body: some View {
        List(viewModel.nearby) { item in
            VStack(alignment: .leading) {
                Text("\(item.stop.code) • \(item.stop.name)")
                Text("~\(Int(item.distanceMeters)) m • \(item.walkingMinutesEstimate) dk yürüyüş")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Yakındaki Duraklar")
        .task { await viewModel.load() }
    }
}
