import UIKit

extension UILabel {
    func addBackground(color: UIColor, cornerRadius: CGFloat = 8, padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)){
        let backgroundView = UIView()
        backgroundView.backgroundColor = color
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.superview?.insertSubview(backgroundView, belowSubview: self)
        
        let screenWidth = UIScreen.main.bounds.width
        let leftPadding = (screenWidth / 2) - (backgroundView.bounds.width / 2) - padding.left
        let rightPadding = (screenWidth / 2) - (backgroundView.bounds.width / 2) - padding.right - 35
        let bottomPadding = 92 - padding.bottom
        let topPadding = 87 - padding.top
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -leftPadding),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: rightPadding),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -topPadding),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomPadding)
               ])
    }
}
