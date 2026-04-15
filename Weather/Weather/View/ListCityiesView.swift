import SwiftUI

struct ListCityiesView: View {
    private let citiesManager = ListCityStorageManager.shared
    @State private var listCityies: [CityListToolbar] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                ScrollView{
                    LazyVStack(spacing: 12) {
                        ForEach(listCityies) { city in
                            cityRow(for: city)
                        }
                    }
                    .padding()
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
                            
                        }
                    }
                    
                    
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
                    Text("\(city.lat.formatted(.number.precision(.fractionLength(2)))), \(city.lon.formatted(.number.precision(.fractionLength(2))))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: city.currentIcon ?? "cloud.fill")
                        .font(.title2)
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
}

#Preview {
    ListCityiesView()
}
