import Foundation

/// The core domain entity shared across all modules.
///
/// This is the single source of truth for what a "university" is in the app.
/// Feature modules pass instances of this type to each other (Listing → Details)
/// and the data layer maps both network DTOs and persisted records to/from it.
public struct University: Identifiable, Equatable, Hashable, Sendable {

    /// Stable identity for the entity.
    ///
    /// The remote API does not expose a unique identifier, so identity is derived
    /// from the (country, name) pair which is unique within the dataset.
    public var id: String { "\(country)#\(name)" }

    public let name: String
    public let country: String
    public let alphaTwoCode: String?
    public let stateProvince: String?
    public let domains: [String]
    public let webPages: [String]

    public init(
        name: String,
        country: String,
        alphaTwoCode: String? = nil,
        stateProvince: String? = nil,
        domains: [String] = [],
        webPages: [String] = []
    ) {
        self.name = name
        self.country = country
        self.alphaTwoCode = alphaTwoCode
        self.stateProvince = stateProvince
        self.domains = domains
        self.webPages = webPages
    }
}
