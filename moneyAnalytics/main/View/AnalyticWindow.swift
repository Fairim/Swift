//
//  AnalyticWindow.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 08/10/2025.
//

import UIKit

class AnalyticWindow: BaseToolbarViewModel {

    private let expensesViewModel = ExpenseCategoryViewModel()
    private let transactionsVM = TransactionsViewModel()
    private let circleView = ExpensesCircleView()
    var currentDate : Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbarSelectedItem(.analytic)
        initialPage()
        DispatchQueue.global(qos: .background).async {
            self.updateSampleData()
            // Возвращаемся в главный поток для обновления UI
            DispatchQueue.main.async {
                self.loadSampleData()
            }
        }
    }
    
    private func initialPage(){
        title = "Анализ транзакций"
        circleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleView)
        
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            circleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            circleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func updateSampleData(){
        let _ = expensesViewModel.CalcExpensesCategoryes(currentDate: currentDate, transactions: transactionsVM.transactions, turn: false)
    }
    
    private func loadSampleData(){
        circleView.expenses = expensesViewModel.expensesCategoryes
        circleView.expenses = expensesViewModel.CalcExpensesCategoryes(currentDate: currentDate, transactions: transactionsVM.transactions, turn: false)
        circleView.updateCircle()
    }
    

}
