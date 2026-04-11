struct DaDataAddress: Decodable {
    let result: String?
    let city: String?
    let settlement: String?
    let geoLat: String?
    let geoLon: String?
    let qcGeo: Int?

    enum CodingKeys: String, CodingKey {
        case result
        case city
        case settlement
        case geoLat = "geo_lat"
        case geoLon = "geo_lon"
        case qcGeo = "qc_geo"
    }
}
