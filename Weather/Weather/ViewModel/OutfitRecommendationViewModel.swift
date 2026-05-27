import Foundation

@MainActor
final class OutfitRecommendationViewModel: ObservableObject {
    @Published var selectedImageName: String = ""
    @Published var summaryText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let adapter = WeatherSnapshotAdapter()
    private let outfitAdvisor = OutfitAdvisorEngine(presets: takePresets())
    
    func loadRecommendation(
        characterType: CharacterType,
        currentWeather: CurrentWeather,
        hourlyWeather: [HourlyWeather]
    ) async {
        isLoading = true
        errorMessage = nil
        let weatherSnapshot = adapter.makeInput(current: currentWeather, hourly: hourlyWeather)
        guard let result = outfitAdvisor.chooseOutfit(characterType: characterType, weather: weatherSnapshot) else {
            isLoading = false
            errorMessage = "Не удалось подобрать образ"
            return
        }
        selectedImageName = result.assetName
        summaryText = RecommendationSummaryBuilder().buildSummary(weather: weatherSnapshot)
        isLoading = false
    }
}
