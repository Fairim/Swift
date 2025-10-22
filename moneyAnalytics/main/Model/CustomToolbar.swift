//
//  CustomToolbar.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 08/10/2025.
//

import UIKit

class CustomToolbar: UIView{
    weak var delegate: CustomToolbarDelegate?
    private var currentState: ToolbarState
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor(named: "DarkBlueGray")
        return stack
    }()
    
    init(state: ToolbarState = ToolbarState()){
        self.currentState = state
        super.init(frame: .zero)
        createUI()
        toolbarUpdate()
    }
    
    required init?(coder: NSCoder){
        self.currentState = ToolbarState()
        super.init(coder: coder)
        createUI()
        toolbarUpdate()
    }
    
    func createUI(){
        backgroundColor = UIColor(named: "DarkBlueGray")
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        for item in currentState.items{
            let button = createToolbarButtton(item)
            stackView.addArrangedSubview(button)
        }
    }
    
    func createToolbarButtton(_ item: ToolbarItems) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: item.iconName), for: .normal)
        button.setTitle(item.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.tintColor = UIColor(named: "IntenseWhite")
        
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        
        button.tag = currentState.items.firstIndex(of: item) ?? 0
        button.addTarget(self, action: #selector(toolbarButtonTapped(_ :)), for: .touchUpInside)
        
        return button
    }
    
    @objc func toolbarButtonTapped(_ sender: UIButton){
        let selectedItem = currentState.items[sender.tag]
        if selectedItem != currentState.selectedItem{
            currentState.selectedItem = selectedItem
            toolbarUpdate()
            delegate?.toolbarDidSelectItem(selectedItem)
        }
    }
    
    func toolbarUpdate(){
        for (index, subview) in stackView.arrangedSubviews.enumerated(){
            guard let button = subview as? UIButton,
                  index < currentState.items.count else { return }
            
            let item = currentState.items[index]
            let isSelected = item == currentState.selectedItem
            
            let color = isSelected ? UIColor(named: "Gold") : UIColor(named: "IntenseWhite")
            button.tintColor = color
            button.setTitleColor(color, for: .normal)
            
            button.setTitle(isSelected ? item.title : "" , for: .normal)
        }
    }
    
    func selectedItem(_ item: ToolbarItems){
        currentState.selectedItem = item
        toolbarUpdate()
    }
}
