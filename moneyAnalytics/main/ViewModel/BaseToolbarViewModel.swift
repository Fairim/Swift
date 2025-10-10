//
//  BaseToolbarViewModel.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 08/10/2025.
//
import UIKit

class BaseToolbarViewModel: UIViewController, CustomToolbarDelegate{
    
    private lazy var customToolbar: CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.delegate = self
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupToolbar()
    }
    
    func setupToolbar(){
        view.addSubview(customToolbar)
        
        NSLayoutConstraint.activate([
            customToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customToolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func toolbarDidSelectItem(_ item: ToolbarItems){
        switch item{
        case .transaction:
            showTransactions()
        case .analytic:
            showAnalytic()
        case .profile:
            showProfile()
        }
    }
    
    func showTransactions(){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let transactionsVC = storyboard.instantiateViewController(
                withIdentifier: "transactions"
            ) as? MainWindow else { return }
            
            // Устанавливаем стиль модальной презентации
            transactionsVC.modalPresentationStyle = .fullScreen
            transactionsVC.modalTransitionStyle = .coverVertical
            
            self.present(transactionsVC, animated: true)
        }
    }
    
    func showAnalytic(){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let analyticVC = storyboard.instantiateViewController(
                withIdentifier: "analytic"
            ) as? AnalyticWindow else { return }
            
            // Устанавливаем стиль модальной презентации
            analyticVC.modalPresentationStyle = .fullScreen
            analyticVC.modalTransitionStyle = .coverVertical
            
            self.present(analyticVC, animated: true)
        }
    }
    
    func showProfile(){
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
    
    func setToolbarSelectedItem(_ item: ToolbarItems) {
        customToolbar.selectedItem(item)
    }
    
}
