enum NetworkErrors: Error {
    case invalidResponse
    case clientError(Int)
    case serverError(Int)
    case unexpectedStatusCode(Int)
    case decodingError(String)
    case networkError(String)
    case invalidURL
    case notInitializedWeather
}
