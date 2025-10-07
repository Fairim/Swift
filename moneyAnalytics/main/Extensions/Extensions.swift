import UIKit

extension UILabel {
    func addBackground(color: UIColor, cornerRadius: CGFloat = 8, verticalPadding: CGFloat = 5) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = color
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Вставляем фон под текущий элемент
        self.superview?.insertSubview(backgroundView, belowSubview: self)
        
        // Получаем супервью для привязки к ширине экрана
        guard let superview = self.superview else { return }
        
        NSLayoutConstraint.activate([
            // Растягиваем на всю ширину супервью (экрана)
            backgroundView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16),
            
            // Вертикальные отступы относительно текста
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -verticalPadding),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: verticalPadding)
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
        priceLabel.text = "\(itemTransaction.price)"
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

extension String {
    var containsOnlyDigits: Bool {
        return rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
