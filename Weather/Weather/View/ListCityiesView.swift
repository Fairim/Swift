import SwiftUI

struct ListCityiesView: View {
    private let citiesManager = ListCityStorageManager.shared
    private let networkManager = NetworkManager.shared
    @State private var listCityies: [CityListToolbar] = []
    @State private var isAddCitySheetPresented = false
    @State private var newCityName = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                if listCityies.isEmpty {
                    ContentUnavailableView(
                        "Города пока не добавлены",
                        systemImage: "building.2.crop.circle",
                        description: Text("Нажмите «Добавить», чтобы сохранить прогноз для нужного города.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView{
                        LazyVStack(spacing: 12) {
                            ForEach(listCityies) { city in
                                cityRow(for: city)
                            }
                        }
                        .padding()
                    }
                }
            }
            
                .navigationTitle("Список городов")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    refreshCities()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Назад") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Добавить"){
                            isAddCitySheetPresented = true
                        }
                        .disabled(isLoading)
                    }
                }
                .sheet(isPresented: $isAddCitySheetPresented) {
                    addCitySheet
                }
                .onAppear {
                    refreshCities()
                }
                .alert("Ошибка", isPresented: errorAlertBinding) {
                    Button("OK", role: .cancel) {
                        errorMessage = nil
                    }
                } message: {
                    Text(errorMessage ?? "Неизвестная ошибка")
                }
                .toolbarBackground(Color.blue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
    
    private func cityRow(for city: CityListToolbar) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name ?? "Без названия")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(formattedCoordinates(for: city))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: city.currentIcon ?? "cloud.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("\(city.currentTemperature)°")
                        .font(.title3.bold())
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.18))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        )
    }
    
    private func refreshCities() {
        listCityies = citiesManager.fetchAllCities()
    }

    private func formattedCoordinates(for city: CityListToolbar) -> String {
        let lat = city.lat.formatted(.number.precision(.fractionLength(4)))
        let lon = city.lon.formatted(.number.precision(.fractionLength(4)))
        return "\(lat), \(lon)"
    }

    private var addCitySheet: some View {
        NavigationStack {
            Form {
                Section("Новый город") {
                    TextField("Введите название города", text: $newCityName)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Добавить город")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        resetAddCityState()
                    }
                    .disabled(isLoading)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isLoading ? "Поиск..." : "Сохранить") {
                        Task {
                            await addCity()
                        }
                    }
                    .disabled(isLoading || newCityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.fraction(0.28)])
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { newValue in
                if !newValue {
                    errorMessage = nil
                }
            }
        )
    }

    @MainActor
    private func addCity() async {
        let cityName = newCityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cityName.isEmpty else {
            errorMessage = "Введите название города."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let coordinates = try await networkManager.cityToCoordinatesRequest(with: cityName)
            try await networkManager.weatherRequest(String(coordinates[0]), String(coordinates[1]))
            refreshCities()
            NotificationCenter.default.post(name: .citiesDidChange, object: nil)
            resetAddCityState()
        } catch {
            errorMessage = userFriendlyMessage(for: error)
        }
    }

    private func resetAddCityState() {
        newCityName = ""
        isAddCitySheetPresented = false
    }

    private func userFriendlyMessage(for error: Error) -> String {
        if let locationError = error as? LocationError {
            switch locationError {
            case .emptyResult, .noCoordinates:
                return "Город не найден. Проверьте название и попробуйте ещё раз."
            case .badStatusCode:
                return "Не удалось получить данные о городе. Попробуйте позже."
            case .invalidURL, .invalidResponse:
                return "Ошибка сервиса геокодирования. Попробуйте позже."
            default:
                return "Не удалось добавить город."
            }
        }

        if let networkError = error as? NetworkErrors {
            switch networkError {
            case .clientError, .serverError, .unexpectedStatusCode, .networkError, .invalidResponse, .invalidURL:
                return "Не удалось загрузить погоду для выбранного города."
            case .decodingError:
                return "Получен некорректный ответ сервера."
            case .notInitializedWeather:
                return "Погода для города ещё не загружена."
            }
        }

        return "Произошла ошибка. Попробуйте ещё раз."
    }
}

#Preview {
    ListCityiesView()
}
