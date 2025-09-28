import Foundation
import UIKit

class profileWindow: UIViewController {
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var categoriLabel: UILabel!
    @IBOutlet weak var categoriesStackView: UIStackView!
    @IBOutlet weak var addButtonCategories: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
