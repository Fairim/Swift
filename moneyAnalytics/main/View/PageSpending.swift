//
//  PageSpending.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 26/09/2025.
//

import Foundation
import UIKit

class ViewSpendingWindow: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var delegate: ViewControllerDelegate?
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var spendingName: UILabel!
    @IBOutlet weak var categorieName: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var reasonSpendingTitle: UILabel!
    @IBOutlet weak var fieldSpending: UITextField!
    @IBOutlet weak var fieldReason: UITextField!
    @IBOutlet weak var fieldPrice: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let alertSpending = UIAlertController(title: "Ошибка",
                                  message: "Введите куда бабки потратил!",
                                  preferredStyle: .alert)
    
    let alertReason = UIAlertController(title: "Ошибка",
                                  message: "Введите причину траты!",
                                  preferredStyle: .alert)
    
    let alertPrice = UIAlertController(title: "Ошибка",
                                  message: "Не корректная сумма!",
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
    
    lazy var allLabels : [UILabel] = [spendingName, categorieName, reasonSpendingTitle, priceTitle]
    lazy var allFields : [UITextField] = [fieldSpending, fieldReason, fieldPrice]
    var transactionsViewModel = TransactionsViewModel()
    var categoriesViewModel = CategoryViewModel()
    var selectedCategory : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Graphite")
        initialSpendingPage()
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSaveButton(_ sender: UIButton) {
        let reasonText: String = fieldReason.text ?? ""
        if reasonText.isEmpty{
            present(alertReason, animated: true, completion: nil)
        }
        else{
            let flag: Int = transactionsViewModel.addTransaction(
                title: fieldSpending.text ?? "",
                category: selectedCategory ?? "Not Category",
                date: Date(),
                price: fieldPrice.text ?? "",
                priceSign: false
            )
            if flag == 1{
                present(alertPrice, animated: true, completion: nil)
            }else if flag == 2{
                present(alertSpending, animated: true, completion: nil)
            }else{
                delegate?.didAddNewTransaction()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func initialSpendingPage(){
        alertPrice.addAction(okAction)
        alertSpending.addAction(okAction)
        alertReason.addAction(okAction)
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
        
        pickerView.delegate = self
        pickerView.dataSource = self
        fieldPrice.keyboardType = .decimalPad
        
        if !categoriesViewModel.categoriesList.isEmpty {
            selectedCategory = categoriesViewModel.categoriesList[0].nameCategory
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = categoriesViewModel.categoriesListNamed[row]
        label.textColor = UIColor(named: "IntenseWhite")
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesViewModel.categoriesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoriesViewModel.categoriesListNamed[row]
    }
}
