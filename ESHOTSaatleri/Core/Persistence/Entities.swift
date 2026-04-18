import Foundation
import SwiftData

@Model
final class FavoriteLineEntity {
    @Attribute(.unique) var lineID: String
    var lineCode: String
    var lineTitle: String
    var createdAt: Date

    init(lineID: String, lineCode: String, lineTitle: String, createdAt: Date = .now) {
        self.lineID = lineID
        self.lineCode = lineCode
        self.lineTitle = lineTitle
        self.createdAt = createdAt
    }
}

@Model
final class FavoriteStopEntity {
    @Attribute(.unique) var stopID: String
    var stopCode: String
    var stopName: String
    var createdAt: Date

    init(stopID: String, stopCode: String, stopName: String, createdAt: Date = .now) {
        self.stopID = stopID
        self.stopCode = stopCode
        self.stopName = stopName
        self.createdAt = createdAt
    }
}

@Model
final class DatasetMetadataEntity {
    @Attribute(.unique) var key: String
    var value: String

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
