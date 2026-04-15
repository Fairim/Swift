import UIKit

final class CustomTabBar: UITabBar {
    private let backgroundLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insetBounds = bounds.insetBy(dx: 10, dy: 8)
        backgroundLayer.path = UIBezierPath(
            roundedRect: insetBounds,
            cornerRadius: 24
        ).cgPath
        backgroundLayer.frame = bounds
        
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
                y: button.frame.origin.y + 15,
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
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var fittedSize = super.sizeThatFits(size)
        fittedSize.height = 88
        return fittedSize
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        isTranslucent = true
        clipsToBounds = false
        
        backgroundLayer.fillColor = UIColor(red: 0.11, green: 0.19, blue: 0.34, alpha: 0.92).cgColor
        backgroundLayer.shadowColor = UIColor.black.cgColor
        backgroundLayer.shadowOpacity = 0.18
        backgroundLayer.shadowRadius = 16
        backgroundLayer.shadowOffset = CGSize(width: 0, height: -4)
        
        layer.insertSublayer(backgroundLayer, at: 0)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
    }
}
