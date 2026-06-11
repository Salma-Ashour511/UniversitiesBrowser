import Foundation

/// Port for fetching universities from a remote source (implemented in the app's
/// data layer on top of `NetworkKit`). The domain stays unaware of HTTP details.
public protocol RemoteUniversitiesDataSource: Sendable {
    func fetch(country: String) async throws -> [University]
}

/// Port for reading/writing the local cache (implemented in `PersistenceKit`).
/// The domain stays unaware of the storage technology (Core Data).
public protocol LocalUniversitiesStore: Sendable {
    /// Replaces the cached universities for the given country.
    func save(_ universities: [University], country: String) async throws

    /// Loads the cached universities for the given country (empty if none).
    func load(country: String) async throws -> [University]
}
