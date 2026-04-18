import Foundation
import SwiftData

final class AppContainer: ObservableObject {
    let modelContainer: ModelContainer
    let networkManager: NetworkManaging
    let gtfsService: GTFSServicing
    let stopsService: StopsServicing
    let timetableService: TimetableServicing
    let liveArrivalService: LiveArrivalServicing
    let locationService: LocationServicing
    let favoritesService: FavoritesServicing
    let routeRepository: RouteRepository
    let stopRepository: StopRepository

    init(
        modelContainer: ModelContainer,
        networkManager: NetworkManaging,
        gtfsService: GTFSServicing,
        stopsService: StopsServicing,
        timetableService: TimetableServicing,
        liveArrivalService: LiveArrivalServicing,
        locationService: LocationServicing,
        favoritesService: FavoritesServicing,
        routeRepository: RouteRepository,
        stopRepository: StopRepository
    ) {
        self.modelContainer = modelContainer
        self.networkManager = networkManager
        self.gtfsService = gtfsService
        self.stopsService = stopsService
        self.timetableService = timetableService
        self.liveArrivalService = liveArrivalService
        self.locationService = locationService
        self.favoritesService = favoritesService
        self.routeRepository = routeRepository
        self.stopRepository = stopRepository
    }

    static func bootstrap() -> AppContainer {
        let schema = Schema([
            FavoriteLineEntity.self,
            FavoriteStopEntity.self,
            DatasetMetadataEntity.self
        ])

        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let modelContainer = try! ModelContainer(for: schema, configurations: [config])

        let network = NetworkManager()
        let parser = GTFSParser()
        let cache = FileDatasetCache()
        let gtfsService = GTFSService(networkManager: network, parser: parser, cache: cache)
        let stopsService = StopsService(networkManager: network, cache: cache)
        let timetableService = TimetableService(gtfsService: gtfsService, stopsService: stopsService)
        let liveArrivalService = LiveArrivalService(networkManager: network)
        let locationService = LocationService()
        let favoritesService = FavoritesService(modelContext: modelContainer.mainContext)
        let routeRepository = DefaultRouteRepository(gtfsService: gtfsService, timetableService: timetableService)
        let stopRepository = DefaultStopRepository(stopsService: stopsService, gtfsService: gtfsService, liveArrivalService: liveArrivalService)

        return AppContainer(
            modelContainer: modelContainer,
            networkManager: network,
            gtfsService: gtfsService,
            stopsService: stopsService,
            timetableService: timetableService,
            liveArrivalService: liveArrivalService,
            locationService: locationService,
            favoritesService: favoritesService,
            routeRepository: routeRepository,
            stopRepository: stopRepository
        )
    }
}
