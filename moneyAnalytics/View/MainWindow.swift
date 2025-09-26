//
//  MainWindow.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 26/09/2025.
import UIKit

class MainWindow: UIViewController {

    @IBOutlet weak var spendingButton: UIButton!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolbar: UIToolbar!
    let backgroundViewMoneyLabel = UIView()
    var allSum : Decimal = 0
    
    var activeDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewDidloadMainPage()
        updateTexts()
    }
    
    @IBAction func clickSpendingButton(_ sender: UIButton) {
        performSegue(withIdentifier:"showSpending", sender: nil)
    }
    
    private func initialViewDidloadMainPage() {
        spendingButton.backgroundColor = UIColor(named: "IntenseRed")
        spendingButton.layer.cornerRadius = 10
        spendingButton.tintColor = UIColor(named: "IntenseWhite")
        incomeButton.backgroundColor = UIColor(named: "IntenseGreen")
        incomeButton.layer.cornerRadius = 10
        incomeButton.tintColor = UIColor(named: "IntenseWhite")
        weekDay.text = "Сегодня"
        weekDay.textColor = UIColor(named: "IntenseWhite")
        dataButton.setTitle(activeDate.formatted(
            Date.FormatStyle()
                .year(.defaultDigits)
                .month(.abbreviated)
                .day(.twoDigits)
        ), for: .normal)
        dataButton.backgroundColor = UIColor(named: "CharcoalBlue")
        dataButton.layer.cornerRadius = 15
        dataButton.tintColor = UIColor(named: "IntenseWhite")
        dataButton.sizeToFit()
        moneyLabel.addBackground(color: UIColor(named: "DarkGreyBlue")!, cornerRadius: 10, padding: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
    }
    
    private func updateTexts(){
        moneyLabel.text = "\(allSum) ₽"
    }
    
}

