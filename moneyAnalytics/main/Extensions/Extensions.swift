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
    
    func addViewTransaction(itemTransaction: TransactionEntity) {
        let itemView = UIView()
        itemView.backgroundColor = UIColor(named: "DarkGreyBlue")
        itemView.layer.cornerRadius = 10
        let heightConstraint = itemView.heightAnchor.constraint(equalToConstant: 80)
        heightConstraint.isActive = true
        heightConstraint.priority = .required
        
        let titleLabel = UILabel()
        titleLabel.text = itemTransaction.title ?? "No Title"
        titleLabel.textColor = UIColor(named: "IntenseWhite")
        titleLabel.numberOfLines = 1
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let priceLabel = UILabel()
        priceLabel.text = "\(itemTransaction.price ?? 0)"
        priceLabel.textColor = itemTransaction.priceSign ? UIColor(named: "IntenseGreen") : UIColor(named: "IntenseRed")
        priceLabel.textAlignment = .right
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let categoryLabel = UILabel()
        categoryLabel.text = itemTransaction.category?.nameCategory ?? "No Category"
        categoryLabel.textColor = .gray
        categoryLabel.numberOfLines = 1
        
        // Добавляем все элементы
        [titleLabel, priceLabel, categoryLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            itemView.addSubview($0)
        }
        stackView.addArrangedSubview(itemView)
        
        NSLayoutConstraint.activate([
            
            itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            itemView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            // Title - слева сверху
            titleLabel.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -8),
            
            // Price - справа сверху
            priceLabel.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            
            // Category - слева снизу
            categoryLabel.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: -12),
            categoryLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: itemView.trailingAnchor, constant: -16),
            
            // Вертикальная связь между элементами
            categoryLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 4)
        ])
    }
}

extension MainWindow: SpendingViewControllerDelegate {
    func didAddNewTransaction() {
        transactionsViewModel.loadTransactions()
        showTransactions()
    }
}
