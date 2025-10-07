//
//  MainWindow.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 26/09/2025.
import UIKit

class MainWindow: UIViewController {

    
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
        createToolBar()
        setupScrollView()
        showTransactions()
    }
    
    @IBAction func clickSpendingButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showSpending", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSpending",
           let spendingVC = segue.destination as? ViewSpendingWindow {
            spendingVC.delegate = self
        }
    }
    
    func showTransactions(){
        stackView.arrangedSubviews.forEach { view in
           stackView.removeArrangedSubview(view)
           view.removeFromSuperview()
        }
        let allTransactions = transactionsViewModel.transactions
        for item in allTransactions{
            if checkDate(item.date!){
                if item.priceSign{
                    allSum += Int(truncating: item.price)
                }else{allSum -= Int(truncating: item.price)}
                updateSumLabel()
                addViewTransaction(itemTransaction: item)
            }
        }
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
    
    
    private func createToolBar(){
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20
        toolbarItem1 = UIBarButtonItem(image: UIImage(systemName: "chart.bar.horizontal.page"), style: .plain, target: self, action: #selector(clickMainItem))
        toolbarText1 = UIBarButtonItem(title: "Транзакции", style: .plain, target: self, action: #selector(clickMainItem))
        toolbarItem1.tintColor = UIColor(named: "Gold")
        toolbarText1.tintColor = UIColor(named: "Gold")
        toolbarItem2 = UIBarButtonItem(image: UIImage(systemName: "chart.xyaxis.line"), style: .plain, target: self, action: #selector(clickAnaliticItem))
        toolbarText2 = UIBarButtonItem(title: "Аналитика", style: .plain, target: self, action: #selector(clickAnaliticItem))
        toolbarItem2.tintColor = .white
        toolbarText2.tintColor = UIColor(named: "Gold")
        toolbarText2.isHidden = true
        toolbarItem3 = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(clickProfileItem))
        toolbarItem3.tintColor = .white
        toolbarText3 = UIBarButtonItem(title: "Профиль", style: .plain, target: self, action: #selector(clickProfileItem))
        toolbarText3.tintColor = UIColor(named: "Gold")
        toolbarText3.isHidden = true
        toolbar.items = [fixedSpace, toolbarItem1, toolbarText1, flexibleSpace, toolbarItem2, toolbarText2, flexibleSpace, toolbarItem3, toolbarText3, fixedSpace, fixedSpace]
        
    }
    
    @objc func clickMainItem() {
        toolbarItem1.tintColor = UIColor(named: "Gold")
        toolbarText1.tintColor = UIColor(named: "Gold")
        toolbarText1.isHidden = false
        toolbarItem2.tintColor = .white
        toolbarText2.tintColor = .white
        toolbarText2.isHidden = true
        toolbarItem3.tintColor = .white
        toolbarText3.tintColor = .white
        toolbarText3.isHidden = true
    }
    
    @objc func clickAnaliticItem() {
        toolbarItem2.tintColor = UIColor(named: "Gold")
        toolbarText2.tintColor = UIColor(named: "Gold")
        toolbarText2.isHidden = false
        toolbarItem1.tintColor = .white
        toolbarText1.tintColor = .white
        toolbarText1.isHidden = true
        toolbarItem3.tintColor = .white
        toolbarText3.tintColor = .white
        toolbarText3.isHidden = true
    }
    
    @objc func clickProfileItem() {
        toolbarItem3.tintColor = UIColor(named: "Gold")
        toolbarText3.tintColor = UIColor(named: "Gold")
        toolbarText3.isHidden = false
        toolbarItem2.tintColor = .white
        toolbarText2.tintColor = .white
        toolbarText2.isHidden = true
        toolbarItem1.tintColor = .white
        toolbarText1.tintColor = .white
        toolbarText1.isHidden = true
        showProfile()
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
    
    private func showProfile() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let profileVC = storyboard.instantiateViewController(
                withIdentifier: "profile"
            ) as? profileWindow else { return }
            
            // Устанавливаем стиль модальной презентации
            profileVC.modalPresentationStyle = .fullScreen
            profileVC.modalTransitionStyle = .coverVertical
            
            self.present(profileVC, animated: true)
        }
    }

    
}

