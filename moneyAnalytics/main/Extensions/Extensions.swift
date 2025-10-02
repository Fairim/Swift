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

extension MainWindow {
    
    func addViewTransaction(itemTransaction: TransactionEntity){
        let itemView = UIView()
        itemView.backgroundColor = UIColor(named: "DarkGreyBlue")
        itemView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = itemTransaction.title
        itemView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(named: "IntenseWhite")
        
        let priceLabel = UILabel()
        priceLabel.text = String(describing: itemTransaction.price)
        priceLabel.textColor = itemTransaction.priceSign ? UIColor(named: "IntenseGreen") : UIColor(named: "IntenseRed")
        
        let categoryLabel = UILabel()
        categoryLabel.text = itemTransaction.category?.nameCategory
        categoryLabel.textColor = .gray
        
        NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
                                     titleLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
                                     priceLabel.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
                                     priceLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
                                     categoryLabel.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
                                     categoryLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor)])
        
        stackView.addArrangedSubview(itemView)
    }
}
