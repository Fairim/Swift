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
    
    private var currentViewController: UIViewController?
    
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
    
    private func switchToViewController(identifier: String) {
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: false)
        }
        
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        addChild(newViewController)
        view.insertSubview(newViewController.view, belowSubview: customToolbar) // Добавляем под тулбар
        
        // Настраиваем констрейнты
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            newViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newViewController.view.bottomAnchor.constraint(equalTo: customToolbar.bottomAnchor)
        ])
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
    
    func showTransactions(){
        switchToViewController(identifier: "transactions")
        setToolbarSelectedItem(.transaction)
    }
    
    func showAnalytic(){
        switchToViewController(identifier: "analytic")
        setToolbarSelectedItem(.analytic)
    }
    
    func showProfile(){
        switchToViewController(identifier: "profile")
        setToolbarSelectedItem(.profile)
    }
        
    
    func setToolbarSelectedItem(_ item: ToolbarItems) {
        customToolbar.selectedItem(item)
    }
    
}
