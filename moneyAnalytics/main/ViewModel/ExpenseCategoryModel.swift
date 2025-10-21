//
//  ExpenseCategoryModel.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 10/10/2025.
//

import Foundation
import UIKit

struct expenseCategory{
    let nameCategory: String
    var amount: Double
    let color: UIColor
}

class ExpenseCategoryViewModel{
    static let shaped = ExpenseCategoryViewModel()
    
    var expensesCategoryes: [expenseCategory] = []
    private let colorPalette: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple,
            .systemPink, .systemTeal, .systemIndigo, .systemBrown, .systemGray,
            .systemYellow, .systemMint, .systemCyan
        ]
    
    func CalcExpensesCategoryes(currentDate: Date, transactions: [TransactionEntity], turn: Bool) -> [expenseCategory]{
        //turn: true - Check day, else Check mounth
        expensesCategoryes.removeAll()
        let formatter = DateFormatter()
        if turn{
            formatter.dateFormat = "yyyy-MM-dd"
        }else{
            formatter.dateFormat = "yyyy-MM"
        }
        let targetDateString = formatter.string(from: currentDate)
        for transaction in transactions {
            let category: String = transaction.category?.nameCategory ?? ""
            let transactionDate : Date = transaction.date
            let price: Decimal = transaction.price as Decimal
            
            let transactionDateString = formatter.string(from: transactionDate)
            
            if targetDateString == transactionDateString {
                let indexElement = findExpensesInd(category)
                if indexElement != -1{
                    expensesCategoryes[indexElement].amount += (price as NSDecimalNumber).doubleValue
                }else{
                    let index = expensesCategoryes.count + 1
                    let category = expenseCategory(nameCategory: category, amount: (price as NSDecimalNumber).doubleValue, color: colorPalette[index % colorPalette.count])
                    if !(category.nameCategory.isEmpty){
                        expensesCategoryes.append(category)
                    }
                }
            }
        }
        return expensesCategoryes
    }
    
    private func findExpensesInd(_ name: String) -> Int{
        if expensesCategoryes.isEmpty { return -1 }
        var trueInd = -1
        for index in 0..<expensesCategoryes.count{
            if expensesCategoryes[index].nameCategory == name{
                trueInd = index
                break
            }
        }
        return trueInd
    }
}
