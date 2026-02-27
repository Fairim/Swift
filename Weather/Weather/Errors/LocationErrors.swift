enum LocationError: Error {
    case servicesDisabled
    case permissionDenied
    case unableToGetLocation
    case authorizationTimeout
    case locationTimeout
    case cityNotFound
    case notInitializedCoordinates
}
