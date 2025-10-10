//
//  PageIncome.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 26/09/2025.
//

import Foundation
import UIKit

class ViewIncomeWindow: UIViewController{
    weak var delegate: ViewControllerDelegate?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sourceIncomeLabel: UILabel!
    @IBOutlet weak var sumIncomeLabel: UILabel!
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var sumIncomeField: UITextField!
    
    let alertIncome = UIAlertController(title: "Ошибка",
                                  message: "Введите откуда бабки получил!",
                                  preferredStyle: .alert)
    
    let alertPrice = UIAlertController(title: "Ошибка",
                                  message: "Не корректная сумма!",
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
    
    
    var transactionsViewModel = TransactionsViewModel()
    
    lazy var allLabels: [UILabel] = [sourceIncomeLabel, sumIncomeLabel]
    lazy var allFields: [UITextField] = [incomeTextField, sumIncomeField]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Graphite")
        initialSpendingPage()
    }
    
    private func  initialSpendingPage(){
        alertIncome.addAction(okAction)
        alertPrice.addAction(okAction)
        cancelButton.backgroundColor = UIColor(named: "CharcoalBlue")
        cancelButton.layer.cornerRadius = 10
        cancelButton.tintColor = UIColor(named: "IntenseRed")
        saveButton.backgroundColor = UIColor(named: "CharcoalBlue")
        saveButton.layer.cornerRadius = 10
        saveButton.tintColor = UIColor(named: "IntenseWhite")
        for label in allLabels{
            label.font = UIFont(name: "Cochin", size: 16)
            label.textColor = UIColor(named: "IntenseWhite")
        }
        
        for field in allFields{
            field.textColor = UIColor(named: "IntenseWhite")
            field.backgroundColor = UIColor(named: "DarkGreyBlue")
            field.layer.borderWidth = 1.0
            field.layer.borderColor = UIColor(named: "CharcoalBlue")?.cgColor
        }
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        let flag: Int = transactionsViewModel.addTransaction(title: incomeTextField.text ?? "", category: "Доход", date: Date(), price: sumIncomeField.text ?? "", priceSign: true)
        if flag == 1{
            present(alertPrice, animated: true, completion: nil)
        }else if flag == 2{
            present(alertIncome, animated: true, completion: nil)
        }else{
            delegate?.didAddNewTransaction()
            dismiss(animated: true, completion: nil)
        }
    }
}
