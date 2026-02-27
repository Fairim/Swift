import CoreLocation

final class LocationModel: NSObject {

    private let manager = CLLocationManager()

    private var authContinuation: CheckedContinuation<CLAuthorizationStatus, Error>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCurrentLocation() async throws -> CLLocation {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationError.servicesDisabled
        }

        // 1) Проверяем статус ДО запроса (это как раз рекомендация из warning)
        let status = manager.authorizationStatus

        // 2) Если не определено — просим разрешение и ждём колбэк
        let finalStatus: CLAuthorizationStatus
        if status == .notDetermined {
            finalStatus = try await requestAuthorization()
        } else {
            finalStatus = status
        }

        // 3) Если нет доступа — ошибка
        switch finalStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return try await requestOneLocation()
        case .denied, .restricted:
            throw LocationError.permissionDenied
        case .notDetermined:
            throw LocationError.permissionDenied
        @unknown default:
            throw LocationError.permissionDenied
        }
    }

    private func requestAuthorization() async throws -> CLAuthorizationStatus {
        if authContinuation != nil { throw LocationError.authorizationTimeout }

        return try await withCheckedThrowingContinuation { continuation in
            authContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }

    private func finishAuth(_ result: Result<CLAuthorizationStatus, Error>) {
        guard let c = authContinuation else { return }
        authContinuation = nil
        c.resume(with: result)
    }

    private func requestOneLocation() async throws -> CLLocation {
        if locationContinuation != nil { throw LocationError.locationTimeout }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }

    private func finishLocation(_ result: Result<CLLocation, Error>) {
        guard let c = locationContinuation else { return }
        locationContinuation = nil
        c.resume(with: result)
    }
}

extension LocationModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if authContinuation != nil {
            finishAuth(.success(status))
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            finishLocation(.failure(LocationError.unableToGetLocation))
            return
        }
        finishLocation(.success(location))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finishLocation(.failure(error))
    }
}
