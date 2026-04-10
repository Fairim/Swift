import SwiftUI

struct locWeatherView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    

    //Первый элемент минимальная температура, второй элемент максимальная температура
    let maxMinDaysTemperatures: [(minT: Double, maxT: Double)] = [(2, 10), (4, 12), (4, 14), (3, 11), (1, 6), (5, 15)]
    //Часовое значения для 24 часов
    let hourlyState: [(temp: Int, state: String, hour: String)] = Array.init(repeating: (15, "sun.max.fill", "00"), count: 26)
    //Массив последующих дней
    let nameDays: [String] = ["Сегодня", "Вт", "Ср", "Чт", "Пт", "Сб"]
    
    let UFIndex: Int = 0
    let windSpeed: Double = 10
    let windDirection: String = "Север"
    let apparentTemperature: Double = 20
    let precipitation: String = "3мм"
    var body: some View {
        
        ZStack{
            //Покраска всего заднего фона
            Image("simpleCloudBack").edgesIgnoringSafeArea(.all)
//            Color.blue.edgesIgnoringSafeArea(.all)
            
            //Главная панель, отображения состояния погоды на данный момент
            VStack(spacing: 5){
                Text("Город")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, screenHeight / 15)
                ZStack{
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white)
                        .padding(3)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                        .opacity(0.6)
                        .frame(maxWidth: screenWidth - 20, maxHeight: screenHeight / 4, alignment: .top)
                    HStack(alignment: .center){
                        VStack(alignment: .leading, spacing: 5){
                            Text("30°")
                                .font(.system(size: 60, weight: .bold, design: .default))
                                .padding(.leading, screenWidth / 12)
                            ZStack{
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color(temperatureColor(currTemp: apparentTemperature)))
                                    .padding(3)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                                    .opacity(0.3)
                                    .frame(minWidth: screenWidth / 2 , maxWidth: screenWidth / 1.5, maxHeight: screenHeight / 7, alignment: .leading)
                                    .padding(.leading, 20)
                                
                                VStack{
                                    HStack{
                                        Image(systemName: "thermometer.variable")
                                        Text("Ощущается как:")
                                    }
                                    .padding(.top, 15)
                                    .padding(.leading, 10)
                                    Text(String(Int(apparentTemperature)))
                                        .font(.system(size: screenWidth / 10, weight: .bold, design: .default))
                                    Text("ТУПщзуьпщзущзьау щьуцзщ ьузцщ щь цущ ьцущзь щзць зщу")
                                        .font(.system(size: screenWidth / 40, weight: .bold, design: .default))
                                        .padding(.leading, 27)
                                        .padding(.trailing, 5)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                        .frame(maxWidth: screenWidth / 2.2)
                        ZStack(alignment: .topTrailing){
                            Image("human")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth / 2.2, height: screenHeight / 4, alignment: .center)
                            Button(action: {}) {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                            }
                            .padding(20)
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                
                
                ScrollView{
                    //Информация по часам
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .padding(3)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                            .opacity(0.2)
                            .frame(width: screenWidth, height: screenHeight / 7.9, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 2){
                                ForEach(Array(hourlyState.enumerated()), id: \.offset) {
                                    index, hourInfo in
                                    VStack{
                                        Text(hourInfo.hour)
                                            .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                                        Image(systemName: hourInfo.state)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30, alignment: .top)
                                            .foregroundColor(.white)
                                            .padding(2)
                                        Text(String(hourInfo.temp))
                                            .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                                    }
                                    .frame(minWidth: screenWidth / 7, maxWidth: screenWidth / 5, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.horizontal, 10)
                    .frame(height: screenHeight / 8)
                    
                    //Информация по дням
                    ZStack(alignment: .top){
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .padding(3)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                            .opacity(0.2)
                            .frame(maxWidth: screenWidth - 10, maxHeight: screenHeight / 2, alignment: .top)
                        
                        VStack(spacing: 2){
                            Text("Прогноз на следующие дни")
                                .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                            ForEach(Array(maxMinDaysTemperatures.enumerated()), id: \.offset) { index, dayTemp in
                                let dayName = nameDays[index]
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .padding(3)
                                        .frame(width: screenWidth - 20, height: screenHeight / 20, alignment: .top)
                                        .opacity(0.3)
                                    HStack(spacing: 2){
                                        Text(dayName)
                                            .font(.system(size: screenWidth / 22, weight: .bold, design: .default))
                                            .frame(maxWidth: screenWidth / 5,  alignment: .leading)
                                        Image(systemName: "cloud.drizzle.fill")
                                            .foregroundColor(.white)
                                            .padding(.horizontal, screenWidth / 20)
                                        Text(String(Int(dayTemp.minT)))
                                            .font(.system(size: screenWidth / 20, weight: .bold, design: .default))
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(temperatureGradient(minTemp: dayTemp.minT, maxTemp: dayTemp.maxT))
                                            .frame(width: screenWidth / 3, height: screenHeight / 80, alignment: .trailing)
                                            .padding(.horizontal, 10)
                                        
                                        Text(String(Int(dayTemp.maxT)))
                                            .font(.system(size: screenWidth / 20, weight: .bold, design: .default))
                                            .frame(maxWidth: screenWidth / 16, alignment: .trailing)
                                        
                                    }
                                    
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                
                    //Ощущаемость и УФ-индекс
                    HStack(spacing: 7){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                                .opacity(0.3)
                            
                            
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                                .opacity(0.3)
                            
                            VStack{
                                HStack{
                                    Image(systemName: "sun.max.fill")
                                    Text("УФ-индекс:")
                                }
                                Text(String(UFIndex))
                                    .font(.system(size: screenWidth / 5, weight: .bold, design: .default))
                            }
                        }
                    }
                    .padding(.vertical, 1)
                    .frame(width: screenWidth - 20, alignment: .center)
                    
                    //Ветер и направление
                    HStack(spacing: 7){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                                .opacity(0.3)
                            
                            VStack{
                                
                            }
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                                .opacity(0.3)
                            
                            VStack{
                                
                            }
                        }
                    }
                    .padding(.vertical, 1)
                    .frame(width: screenWidth - 20, alignment: .center)
                    
                    //Осадки и влажность
                    HStack(spacing: 7){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                                .opacity(0.3)
                            
                            VStack{
                                
                            }
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: screenWidth / 2 - 15, height: screenHeight / 5)
                                .opacity(0.3)
                            
                            VStack{
                                HStack{
                                    Image(systemName: "drop.fill")
                                    Text("Влажность:")
                                }
                                Text(String(UFIndex))
                                    .font(.system(size: screenWidth / 5, weight: .bold, design: .default))
                            }
                        }
                    }
                    .padding(.vertical, 1)
                    .frame(width: screenWidth - 20, alignment: .center)
                //Тут Кончается скролл
                }
                
            }
        }
    }
    
    private func temperatureGradient(minTemp: Double, maxTemp: Double) -> LinearGradient {
        let colors: [Color]
        
        // Определяем цвета на основе температуры
        let avgTemp = (minTemp + maxTemp) / 2
        
        if avgTemp < 0 {
            colors = [Color.blue, Color.cyan]
        } else if avgTemp < 10 {
            colors = [Color.cyan, Color.green]
        } else if avgTemp < 20 {
            colors = [Color.green, Color.yellow]
        } else if avgTemp < 30 {
            colors = [Color.yellow, Color.orange]
        } else {
            colors = [Color.orange, Color.red]
        }
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func temperatureColor(currTemp: Double) -> UIColor {
        switch(currTemp){
        case (-30)...(-20):
            return UIColor(.blue)
        case (-19)...(-1):
            return UIColor(.cyan)
        case 1...15:
            return UIColor(.yellow)
        case 16...25:
            return UIColor(.orange)
        case 26...50:
            return UIColor(.red)
        default:
            return UIColor(.white)
        }
    }
    
    private func currentBack(state: String, isDay: Bool) -> Image {
        switch(state) {
        case "cloudy-sunny":
            if isDay{ return Image("simpleCloudBack") }
            return Image("cloudNightBack")
        case "rain-ice":
            if isDay{ return Image("rainIceBack") }
            return Image("rainIceNightBack")
        case "simpleRain":
            if isDay{ return Image("simpleRainBack") }
            return Image("simpleRainNightBack")
        case "strongRain":
            if isDay{ return Image("strongRainBack") }
            return Image("strongRainNightBack")
        case "simpleSnow":
            if isDay{ return Image("simpleSnowBack") }
            return Image("simpleSnowNightBack")
        case "strongSnow":
            if isDay{ return Image("strongSnowBack") }
            return Image("strongSnowNightBack")
        case "wind":
            if isDay{ return Image("strongSnowBack") }
            return Image("strongSnowNightBack")
        default:
            if isDay{ return Image("cloudNightBack") }
            return Image("sunnyBack")
        }
    }
    
}



#Preview {
    locWeatherView()
}
