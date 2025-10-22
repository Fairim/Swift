//
//  AnalyticWindow.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 08/10/2025.
//

import UIKit

class AnalyticWindow: UIViewController {

    private let expensesViewModel = ExpenseCategoryViewModel()
    private let transactionsVM = TransactionsViewModel()
    private let circleView = ExpensesCircleView()
    var currentDate : Date = Date()
    private let scrollView: UIScrollView = UIScrollView()
    private let stackView: UIStackView = UIStackView()
    private let segments: UISegmentedControl = UISegmentedControl()
    private var expensesCategoryes: [expenseCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialPage()
        DispatchQueue.global(qos: .background).async {
            self.updateSampleData(false)
            // Возвращаемся в главный поток для обновления UI
            DispatchQueue.main.async {
                self.loadSampleData()
                self.showStackCategories()
            }
        }
    }
    
    private func initialPage(){
        title = "Анализ транзакций"
        circleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleView)
        segments.insertSegment(withTitle: "за день", at: 0, animated: true)
        segments.insertSegment(withTitle: "за месяц", at: 1, animated: true)
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = 1
        segments.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segments)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        let heightConstraintCircleView = circleView.heightAnchor.constraint(equalToConstant: 400)
        heightConstraintCircleView.isActive = true
        heightConstraintCircleView.priority = .required
        
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            circleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            circleView.heightAnchor.constraint(equalToConstant: 400),

            segments.topAnchor.constraint(equalTo: circleView.bottomAnchor),
            segments.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segments.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            scrollView.topAnchor.constraint(equalTo: segments.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func showStackCategories(){
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for expense in expensesCategoryes{
            let itemView = UIView()
            let titleCategory = UILabel()
            let priceLabel = UILabel()
            
            itemView.backgroundColor = UIColor(named: "OxfordBlue")
            itemView.layer.cornerRadius = 10
            itemView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            titleCategory.text = expense.nameCategory
            titleCategory.textColor = expense.color
            titleCategory.numberOfLines = 1
            titleCategory.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            priceLabel.text = "\(expense.amount)"
            priceLabel.textColor = UIColor(named: "IntenseWhite")
            priceLabel.textAlignment = .right
            priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            [titleCategory, priceLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                itemView.addSubview($0)
            }
            stackView.addArrangedSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                itemView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                
                titleCategory.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 10),
                titleCategory.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 20),
                titleCategory.trailingAnchor.constraint(greaterThanOrEqualTo: priceLabel.trailingAnchor, constant: -10),
                
                priceLabel.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 10),
                priceLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -20),
                priceLabel.leadingAnchor.constraint(lessThanOrEqualTo: titleCategory.trailingAnchor, constant: 10),
            ])
            
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            DispatchQueue.global(qos: .background).async {
                self.updateSampleData(true)
                DispatchQueue.main.async {
                    self.loadSampleData()
                    self.showStackCategories()
                }
            }
        case 1:
            DispatchQueue.global(qos: .background).async {
                self.updateSampleData(false)
                DispatchQueue.main.async {
                    self.loadSampleData()
                    self.showStackCategories()
                }
            }
        default:
            break
        }
    }
    
    private func updateSampleData(_ flag_month: Bool){
        expensesCategoryes = expensesViewModel.CalcExpensesCategoryes(currentDate: currentDate, transactions: transactionsVM.transactions, turn: flag_month)
    }
    
    private func loadSampleData(){
        circleView.expenses = expensesViewModel.expensesCategoryes
        circleView.updateCircle()
    }
    
    
    

}
