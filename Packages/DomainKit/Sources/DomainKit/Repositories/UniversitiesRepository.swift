import Foundation

/// Use-case boundary consumed by the feature Interactors.
///
/// Implementations orchestrate the remote source and the local cache. Feature
/// modules depend only on this protocol and `University`, never on the concrete
/// network/persistence packages.
public protocol UniversitiesRepositoryProtocol: Sendable {

    /// Loads universities for a country with a cache fallback.
    ///
    /// Behaviour:
    /// 1. Try the network; on success, refresh the cache and return `.remote`.
    /// 2. On network failure, return cached data (if any) tagged `.cache`.
    /// 3. If both fail, throw an `AppError`.
    func loadUniversities(country: String) async throws -> UniversitiesLoadResult

    /// Forces a fresh network fetch and updates the cache. Used by the
    /// Details → Listing "Refresh" flow. Throws if the network fetch fails.
    func refreshUniversities(country: String) async throws -> [University]
}

/// Default orchestration of remote + local data sources.
///
/// Lives in the domain because it depends only on domain ports — this keeps the
/// caching policy testable in isolation and free of framework imports.
public final class DefaultUniversitiesRepository: UniversitiesRepositoryProtocol {

    private let remote: RemoteUniversitiesDataSource
    private let local: LocalUniversitiesStore

    public init(remote: RemoteUniversitiesDataSource, local: LocalUniversitiesStore) {
        self.remote = remote
        self.local = local
    }

    public func loadUniversities(country: String) async throws -> UniversitiesLoadResult {
        do {
            let remoteUniversities = try await remote.fetch(country: country)
            // Refresh the cache on every successful network load.
            try? await local.save(remoteUniversities, country: country)
            return UniversitiesLoadResult(universities: remoteUniversities, source: .remote)
        } catch {
            // Network failed — fall back to whatever we cached previously.
            let cached = (try? await local.load(country: country)) ?? []
            guard !cached.isEmpty else {
                throw mapToAppError(error)
            }
            return UniversitiesLoadResult(universities: cached, source: .cache)
        }
    }

    public func refreshUniversities(country: String) async throws -> [University] {
        do {
            let remoteUniversities = try await remote.fetch(country: country)
            try? await local.save(remoteUniversities, country: country)
            return remoteUniversities
        } catch {
            throw mapToAppError(error)
        }
    }

    private func mapToAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError { return appError }
        return .network
    }
}
