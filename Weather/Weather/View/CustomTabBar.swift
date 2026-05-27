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
        
        let insetBounds = CGRect(
            x: 10,
            y: -12,
            width: bounds.width - 20,
            height: bounds.height - 8
        )
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
        
        let horizontalInset: CGFloat = 18
        let spacing: CGFloat = 8
        let centerButtonWidth: CGFloat = 44
        let trailingAccessoryWidth: CGFloat = 44
        let trailingAccessorySpacing: CGFloat = 12
        let buttonY = insetBounds.midY
        let centerGroupWidth = centerButtonWidth * CGFloat(max(centerButtons.count, 1))
        let centerStartX = bounds.midX - (centerGroupWidth / 2)
        let leftAvailableWidth = max(centerStartX - horizontalInset - spacing, 0)
        let rightStartX = centerStartX + centerGroupWidth + spacing
        let rightBoundary = bounds.width - horizontalInset - trailingAccessoryWidth - trailingAccessorySpacing
        let rightAvailableWidth = max(rightBoundary - rightStartX, 0)

        let leftButtonWidth = leftAvailableWidth / CGFloat(max(leftButtons.count, 1))
        for (index, button) in leftButtons.enumerated() {
            let buttonHeight = button.frame.height
            button.frame = CGRect(
                x: horizontalInset + CGFloat(index) * leftButtonWidth,
                y: buttonY - (buttonHeight / 2),
                width: leftButtonWidth,
                height: buttonHeight
            )
        }
        
        var currentCenterX = centerStartX
        for button in centerButtons {
            let buttonHeight = button.frame.height
            button.frame = CGRect(
                x: currentCenterX,
                y: buttonY - (buttonHeight / 2),
                width: centerButtonWidth,
                height: buttonHeight
            )
            currentCenterX += centerButtonWidth
        }
        
        let rightButtonWidth = rightAvailableWidth / CGFloat(max(rightButtons.count, 1))
        for (index, button) in rightButtons.enumerated() {
            let buttonHeight = button.frame.height
            button.frame = CGRect(
                x: rightStartX + CGFloat(index) * rightButtonWidth,
                y: buttonY - (buttonHeight / 2),
                width: rightButtonWidth,
                height: buttonHeight
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
