import Foundation
import UIKit

class profileWindow: UIViewController{
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var redactUserNameButton: UIButton!
    @IBOutlet weak var addButtonCategories: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesStackView: UIStackView!
    @IBOutlet weak var textAvailableCat: UILabel!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var saveCategoryButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    
    var textLabelIsHidden : Bool = false
    
    let alertTrueCategory = UIAlertController(title: "Ошибка",
                                  message: "Перед сохранением, необходимо ввести название категории!",
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
    
    lazy var allButton: [UIButton] = [redactUserNameButton, addButtonCategories, deleteButton, saveCategoryButton]
    lazy var allLabels: [UILabel] = [profileLabel, userName, textAvailableCat]
    
    var allButtonSV: [UIButton] = []
    
    let categoriesViewModel = CategoryViewModel()
    let appSettingsVM = SettingViewModel()
    var currInd: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialProfileWindow()
        setupScrollViewConstraints()
    }
    
    private func setupScrollViewConstraints() {
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(categoriesScrollView.constraints)
        
        NSLayoutConstraint.activate([
            categoriesStackView.topAnchor.constraint(equalTo: categoriesScrollView.contentLayoutGuide.topAnchor),
            categoriesStackView.leadingAnchor.constraint(equalTo: categoriesScrollView.contentLayoutGuide.leadingAnchor),
            categoriesStackView.trailingAnchor.constraint(equalTo: categoriesScrollView.contentLayoutGuide.trailingAnchor),
            categoriesStackView.bottomAnchor.constraint(equalTo: categoriesScrollView.contentLayoutGuide.bottomAnchor),
            categoriesStackView.widthAnchor.constraint(equalTo: categoriesScrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    
    func initialProfileWindow(){
        userName.text = appSettingsVM.getNameUser()
        userNameField.isHidden = true
        alertTrueCategory.addAction(okAction)
        redactUserNameButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        redactUserNameButton.setTitle("", for: .normal)
        deleteButton.isHidden = true
        saveCategoryButton.isHidden = true
        saveCategoryButton.setTitle("", for: .normal)
        saveCategoryButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        categoryField.isHidden = true
        categoryField.textColor = UIColor(named: "IntenseWhite")
        categoryField.backgroundColor = .darkGray
        userNameField.isHidden = true
        userNameField.textColor = UIColor(named: "IntenseWhite")
        userNameField.backgroundColor = .darkGray
        for button in allButton {
            button.backgroundColor = UIColor(named: "CharcoalBlue")
            button.tintColor = UIColor(named: "IntenseWhite")
            button.layer.cornerRadius = 10
        }
        saveCategoryButton.backgroundColor = UIColor(named: "IntenseGreen")
        
        for label in allLabels {
            label.textColor = UIColor(named: "IntenseWhite")
        }
        
        categoriesStackView.axis = .vertical
        categoriesStackView.spacing = 8
        categoriesStackView.distribution = .fillEqually
        categoriesStackView.alignment = .fill
        
        showAllCategories()
    }
    
    func showAllCategories(){
        allButtonSV.removeAll()
        categoriesStackView.arrangedSubviews.forEach { view in
            categoriesStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        let categoriesList = categoriesViewModel.categoriesList
        for (index, category) in categoriesList.enumerated(){
            addCategoryStackView(category, index)
        }
        
        currInd = -1
        deleteButton.isHidden = true
    }
    
    private func addCategoryStackView(_ category: CategoriesEntity, _ index: Int){
        let button = UIButton()
        button.setTitle(category.nameCategory, for: .normal)
        button.setTitleColor(UIColor(named: "IntenseWhite"), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.tag = index
        button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
        allButtonSV.append(button)
        
        categoriesStackView.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        DispatchQueue.main.async {
           self.categoriesStackView.layoutIfNeeded()
       }
    }
    
    @objc func categoryTapped(_ sender: UIButton){
        for tButton in allButtonSV {
            tButton.backgroundColor = .gray
        }
        
        sender.backgroundColor = UIColor(named: "CharcoalBlue")
        
        currInd = sender.tag
        deleteButton.isHidden = false
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        guard currInd >= 0 && currInd < categoriesViewModel.categoriesList.count else { return }
        
        let categoryToDelete = categoriesViewModel.categoriesList[currInd]
        categoriesViewModel.deleteCategory(category: categoryToDelete)
        
        showAllCategories()
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        saveCategoryButton.isHidden = false
        categoryField.isHidden = false
    }
    
    @IBAction func tapSaveCategoryButton(_ sender: Any) {
        let textInCategoryField = categoryField.text ?? ""
        if !textInCategoryField.isEmpty{
            categoriesViewModel.addCategory(nameCategory: textInCategoryField)
            categoryField.text = ""
            saveCategoryButton.isHidden = true
            categoryField.isHidden = true
            showAllCategories()
        }else{
            present(alertTrueCategory, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapRedactButton(_ sender: Any) {
        if userName.isHidden{
            userName.isHidden = false
            userName.text = userNameField.text
            appSettingsVM.saveUserName(userNameField.text ?? "")
            userNameField.isHidden = true
        }else{
            userName.isHidden = true
            userNameField.text = userName.text
            userNameField.isHidden = false
        }
    }
}
