import Foundation

/// Describes where a successfully loaded list of universities came from.
///
/// The Listing screen uses this to surface a subtle "showing cached data" hint
/// when the network failed but a local copy was available.
public enum DataSource: Sendable, Equatable {
    case remote
    case cache
}

/// The result of loading universities, pairing the data with its origin.
public struct UniversitiesLoadResult: Sendable, Equatable {
    public let universities: [University]
    public let source: DataSource

    public init(universities: [University], source: DataSource) {
        self.universities = universities
        self.source = source
    }
}
