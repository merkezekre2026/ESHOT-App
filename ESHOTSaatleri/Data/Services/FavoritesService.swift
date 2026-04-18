import Foundation
import SwiftData

protocol FavoritesServicing {
    func favoriteLines() throws -> [FavoriteLineEntity]
    func favoriteStops() throws -> [FavoriteStopEntity]
    func toggleLine(_ line: BusLine) throws
    func toggleStop(_ stop: BusStop) throws
}

final class FavoritesService: FavoritesServicing {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func favoriteLines() throws -> [FavoriteLineEntity] {
        try modelContext.fetch(FetchDescriptor<FavoriteLineEntity>())
    }

    func favoriteStops() throws -> [FavoriteStopEntity] {
        try modelContext.fetch(FetchDescriptor<FavoriteStopEntity>())
    }

    func toggleLine(_ line: BusLine) throws {
        let predicate = #Predicate<FavoriteLineEntity> { $0.lineID == line.id }
        let existing = try modelContext.fetch(FetchDescriptor(predicate: predicate)).first
        if let existing {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteLineEntity(lineID: line.id, lineCode: line.code, lineTitle: line.title))
        }
        try modelContext.save()
    }

    func toggleStop(_ stop: BusStop) throws {
        let predicate = #Predicate<FavoriteStopEntity> { $0.stopID == stop.id }
        let existing = try modelContext.fetch(FetchDescriptor(predicate: predicate)).first
        if let existing {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteStopEntity(stopID: stop.id, stopCode: stop.code, stopName: stop.name))
        }
        try modelContext.save()
    }
}
