//
//  PageSpending.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 26/09/2025.
//

import Foundation
import UIKit

class ViewSpendingWindow: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var spendingName: UILabel!
    @IBOutlet weak var categorieName: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var reasonSpendingTitle: UILabel!
    @IBOutlet weak var fieldSpending: UITextField!
    @IBOutlet weak var fieldReason: UITextField!
    @IBOutlet weak var fieldPrice: UITextField!
    lazy var allLabels : [UILabel] = [spendingName, categorieName, reasonSpendingTitle, priceTitle]
    lazy var allFields : [UITextField] = [fieldSpending, fieldReason, fieldPrice]
    var transactionsViewModel = TransactionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Graphite")
        initialSpendingPage()
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSaveButton(_ sender: UIButton) {
        transactionsViewModel.addTransaction(title: spendingName.text ?? "", category: categorieName.text ?? "", date: Date(), price: NSDecimalNumber(string: priceTitle.text) as Decimal, priceSign: false)
        dismiss(animated: true, completion: nil)
    }
    
    private func initialSpendingPage(){
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
        
        fieldPrice.keyboardType = .decimalPad
    }
}
