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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var toolbar: UIToolbar!
    private var toolbarItem1: UIBarButtonItem!
    private var toolbarItem2: UIBarButtonItem!
    private var toolbarItem3: UIBarButtonItem!
    private var toolbarText1: UIBarButtonItem!
    private var toolbarText2: UIBarButtonItem!
    private var toolbarText3: UIBarButtonItem!
    let backgroundViewMoneyLabel = UIView()
    var allSum : Decimal = 0
    var transactionsViewModel = TransactionsViewModel()
    var activeDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewDidloadMainPage()
        updateTexts()
        createToolBar()
        showTransactions()
    }
    
    @IBAction func clickSpendingButton(_ sender: UIButton) {
        performSegue(withIdentifier:"showSpending", sender: nil)
    }
    
    private func showTransactions(){
        var allTransactions = transactionsViewModel.transactions
        for item in allTransactions{
            addViewTransaction(itemTransaction: item)
        }
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
    
    private func updateTexts(){
        moneyLabel.text = "\(allSum) ₽"
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

