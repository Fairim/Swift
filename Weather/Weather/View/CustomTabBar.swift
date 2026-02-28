import UIKit

final class CustomTabBar: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let items = items else { return }
        
        let tabBarButtons = subviews.filter { $0 is UIControl }
        
        var leftButtons: [UIView] = []
        var centerButtons: [UIView] = []
        var rightButtons: [UIView] = []
        
        for (index, button) in tabBarButtons.enumerated() {
            if index < items.count {
                if let item = items[index] as? CustomTabBarItem {
                    switch item.position {
                    case .left:
                        leftButtons.append(button)
                    case .center:
                        centerButtons.append(button)
                    case .right:
                        rightButtons.append(button)
                    }
                }
            }
        }
        
        let tabBarWidth = bounds.width
        let leftWidth = tabBarWidth * 0.2
        let rightWidth = tabBarWidth * 0.2
        let centerWidth = tabBarWidth * 0.6
        
        //Позиционируем левую группу
        let leftButtonWidth = leftWidth / CGFloat(max(leftButtons.count, 1))
        for (index, button) in leftButtons.enumerated() {
            button.frame = CGRect(
                x: CGFloat(index) * leftButtonWidth,
                y: button.frame.origin.y,
                width: leftButtonWidth,
                height: button.frame.height
            )
        }
        
        // Позиционируем центральную группу
        //Нельзя так делать, нужно чтобы она сама регулировалась, но мы так сделаем:)
        let centerButtonWidth = centerWidth / CGFloat(12)
        let centerButtonX = leftWidth + (centerWidth / 2)
        var startX = centerButtonX - (centerButtonWidth * CGFloat(centerButtons.count) / 2)
        for (_, button) in centerButtons.enumerated() {
            button.frame = CGRect(
                x: startX,
                y: button.frame.origin.y,
                width: centerButtonWidth,
                height: button.frame.height
            )
            startX += centerButtonWidth
        }
        
        // Позиционируем правую группу
        let rightButtonWidth = rightWidth / CGFloat(max(rightButtons.count, 1))
        for (index, button) in rightButtons.enumerated() {
            button.frame = CGRect(
                x: leftWidth + centerWidth + CGFloat(index) * rightButtonWidth,
                y: button.frame.origin.y,
                width: rightButtonWidth,
                height: button.frame.height
            )
        }
        
    }
}
