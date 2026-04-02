import UIKit
import SnapKit

class WeatherStatusCard: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.text = "--°"
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let mainStackView = UIStackView(arrangedSubviews: [temperatureLabel, characterImageView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .center
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with temperature: Double) {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                self.temperatureLabel.text = "\(Int(temperature))°"
                
                // Настройка персонажа
//                self.configureCharacter(with: weather.clothingAdvice)
            }
        }
}
