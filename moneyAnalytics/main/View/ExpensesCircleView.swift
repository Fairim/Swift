//
//  ExpensesCircleView.swift
//  moneyAnalytics
//
//  Created by Jorgen Boring on 10/10/2025.
//

import UIKit

class ExpensesCircleView: UIView {

    private var circleLayer = CAShapeLayer()
    private var backgroundCircleLayer = CAShapeLayer()
    
    var expenses: [expenseCategory] = [] {
        didSet{
            updateCircle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        updateCircle()
    }
    
    private func setupLayers(){
        //Создаем задний фон для нашего круга, очистив середину
        backgroundCircleLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.lineWidth = 20
        layer.addSublayer(backgroundCircleLayer)
        
        //Создаем основное тело, которое будет отображать разделы
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 20
        circleLayer.lineCap = .round
        layer.addSublayer(circleLayer)
    }
    
    func updateCircle(){
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 40
        var currentStartAngle = -CGFloat.pi / 2
        
        let backgroundPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: currentStartAngle,
            endAngle: CGFloat.pi * 2 - CGFloat.pi / 2,
            clockwise: true)
        backgroundCircleLayer.path = backgroundPath.cgPath
        
        let totalAmound = expenses.reduce(0) { $0 + $1.amount }
        
        layer.sublayers?.removeAll { $0 != backgroundCircleLayer && $0 != circleLayer }
        
        for expense in expenses {
            let segmentLayer = CAShapeLayer()
            let percentage = CGFloat(expense.amount) / CGFloat(totalAmound)
            let endAngle = currentStartAngle + 2 * CGFloat.pi * percentage
            
            let segmentPath = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: currentStartAngle,
                endAngle: endAngle,
                clockwise: true)
            
            segmentLayer.path = segmentPath.cgPath
            segmentLayer.strokeColor = expense.color.cgColor
            segmentLayer.fillColor = UIColor.clear.cgColor
            segmentLayer.lineWidth = 20
            segmentLayer.lineCap = .round
            
            layer.addSublayer(segmentLayer)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.8
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            segmentLayer.add(animation, forKey: "animateStroke")
            
            currentStartAngle = endAngle
        }
        
    }
    
}
