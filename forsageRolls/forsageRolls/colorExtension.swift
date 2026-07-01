import SwiftUI

extension Color {
    init(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanHex.hasPrefix("#") {
            cleanHex.remove(at: cleanHex.startIndex)
        }
        
        // Переменная для хранения числового значения
        var rgbValue: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&rgbValue)
        
        let r, g, b, a: Double
        
        switch cleanHex.count {
        case 6: // Формат #RRGGBB
            r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            b = Double(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        case 8: // Формат #RRGGBBAA (включая прозрачность)
            r = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            g = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = Double((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = Double(rgbValue & 0x000000FF) / 255.0
        default: // Если формат неверный, возвращаем прозрачный цвет
            r = 0; g = 0; b = 0; a = 0
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

extension LinearGradient {
    static let gradientOrange = LinearGradient(
        colors: [Color(hex: "FF6347"), Color(hex: "FF826C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
