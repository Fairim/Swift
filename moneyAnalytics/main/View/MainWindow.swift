//
//  MainWindow.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 26/09/2025.
import UIKit

class MainWindow: BaseToolbarViewModel {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var spendingButton: UIButton!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var toolbar: UIToolbar!
    private var toolbarItem1: UIBarButtonItem!
    private var toolbarItem2: UIBarButtonItem!
    private var toolbarItem3: UIBarButtonItem!
    private var toolbarText1: UIBarButtonItem!
    private var toolbarText2: UIBarButtonItem!
    private var toolbarText3: UIBarButtonItem!
    let backgroundViewMoneyLabel = UIView()
    var allSum : Int = 0
    var transactionsViewModel = TransactionsViewModel()
    var activeDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewDidloadMainPage()
        setToolbarSelectedItem(.transaction)
        setupScrollView()
        showTransactionsEntitis()
    }
    
    @IBAction func clickSpendingButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showSpending", sender: nil)
    }
    
    @IBAction func clickIncomeButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showIncome", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSpending",
           let spendingVC = segue.destination as? ViewSpendingWindow {
            spendingVC.delegate = self
        }else if segue.identifier == "showIncome",  let incomeVC = segue.destination as? ViewIncomeWindow {
            incomeVC.delegate = self
        }
    }
    
    func showTransactionsEntitis(){
        stackView.arrangedSubviews.forEach { view in
           stackView.removeArrangedSubview(view)
           view.removeFromSuperview()
        }
        let allTransactions = transactionsViewModel.transactions
        for item in allTransactions{
            if checkDate(item.date){
                if item.priceSign{
                    allSum += Int(truncating: item.price)
                }else{allSum -= Int(truncating: item.price)}
                updateSumLabel()
                addViewTransaction(itemTransaction: item)
            }
        }
        updateSumLabel()
    }
    
    func setupScrollView(){
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10

        stackView.constraints.forEach { constraint in
           if constraint.firstAttribute == .height {
               constraint.isActive = false
           }
       }
        
        NSLayoutConstraint.activate([
           stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
           stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
           stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
           
        ])
    }
    
    func checkDate(_ currentDate: Date) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if formatter.string(from: currentDate) == formatter.string(from: Date()){
            return true
        }
        return false
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
        moneyLabel.addBackground(color: UIColor(named: "DarkGreyBlue")!, cornerRadius: 10, verticalPadding: moneyLabel.bounds.height + 60)
    }
    
    private func updateSumLabel(){
        if allSum < 0{
            moneyLabel.textColor = UIColor(named: "IntenseRed")
        } else {moneyLabel.textColor = UIColor(named: "IntenseGreen")}
        moneyLabel.text = "\(allSum) ₽"
        NSLayoutConstraint.activate([
            moneyLabel.centerXAnchor.constraint(equalTo: myView.centerXAnchor)
        ])
    }
    
}

