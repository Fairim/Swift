enum LocationError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case emptyResult
    case noCoordinates
    case servicesDisabled
    case permissionDenied
    case authorizationTimeout
    case locationTimeout
    case unableToGetLocation
}
