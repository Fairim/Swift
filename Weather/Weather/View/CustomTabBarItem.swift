import UIKit

enum TabPosition {
    case left, center, right
}

class CustomTabBarItem: UITabBarItem {
    var position: TabPosition = .center
    var iconSize: CGFloat = 16
    
    convenience init(title: String?, imageName: String, tag: Int, position: TabPosition, iconSize: CGFloat = 16) {
        let config = UIImage.SymbolConfiguration(pointSize: iconSize)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        self.init(title: title, image: image, tag: tag)
        self.position = position
        self.iconSize = iconSize
    }
}
