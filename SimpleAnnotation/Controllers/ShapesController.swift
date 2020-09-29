//
//  ShapesController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 8/14/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol ShapesControllerDelegate {
    func shapeesParameter(shape: Shapes, color: UIColor, width: CGFloat, opacity: CGFloat)
    func cancel()
}

class ShapesController: UIViewController {
    
    // MARK: Variables
    
    var delegate: ShapesControllerDelegate?
    
    var shape: Shapes = .line {
        didSet {
            delegate?.shapeesParameter(shape: shape, color: color, width: thikness, opacity: opacity)
        }
    }
    
    var color: UIColor = .black {
        didSet {
            delegate?.shapeesParameter(shape: shape, color: color, width: thikness, opacity: opacity)
        }
    }
    
    var thikness: CGFloat = 5.0 {
        didSet {
            delegate?.shapeesParameter(shape: shape, color: color, width: thikness, opacity: opacity)
        }
    }
    
    var opacity: CGFloat = 1.0 {
        didSet {
            delegate?.shapeesParameter(shape: shape, color: color, width: thikness, opacity: opacity)
        }
    }
    
    var fullView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (opacitiesStack.frame.maxY + navigationBarHeight)
    }
    
    var partialView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (colorsStack.frame.maxY + navigationBarHeight)
    }
    
    var colorButtons: [ColorButton] = []
    var opacityButtons: [OpacityButton] = []
    
    // MARK: Properties
    
    let colorsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let thicknessView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let thicknessSizeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "20.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thicknessSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 10
        slider.maximumValue = 50
        slider.setValue(20, animated: false)
        slider.addTarget(self, action: #selector(handleSliderChange(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let opacitiesStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // holdView
        let holdView = UIView(frame: .zero)
        holdView.layer.cornerRadius = 2
        holdView.layer.masksToBounds = true
        holdView.backgroundColor = .lightGray
        holdView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(holdView)
        NSLayoutConstraint.activate([
            holdView.widthAnchor.constraint(equalToConstant: 64),
            holdView.heightAnchor.constraint(equalToConstant: 4),
            holdView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            holdView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        
        // titleLabel
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Shapes"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: holdView.bottomAnchor, constant: 16)
        ])
        
        // closeButton
        let closeButton = UIButton(frame: .zero)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // shapes
        let items = [UIImage(named: "line_w"),
                     UIImage(named: "arrow_w"),
                     UIImage(named: "resize_w"),
                     UIImage(named: "rectangle_w"),
                     UIImage(named: "circle_w"),
                     UIImage(named: "check_w"),
                     UIImage(named: "none_w")]
        
        let shapesSegmentedControl = UISegmentedControl(items: items as [Any])
        shapesSegmentedControl.layer.cornerRadius = 4.0
        shapesSegmentedControl.backgroundColor = .clear
        shapesSegmentedControl.tintColor = .white
        shapesSegmentedControl.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.5)
        shapesSegmentedControl.addTarget(self, action: #selector(changeShspes(_:)), for: .valueChanged)
        shapesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(shapesSegmentedControl)
        NSLayoutConstraint.activate([
            shapesSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            shapesSegmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            shapesSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shapesSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // colorLabel
        let colorLabel = UILabel(frame: .zero)
        colorLabel.text = "COLOR"
        colorLabel.textColor = .gray
        colorLabel.font = UIFont.systemFont(ofSize: 14)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorLabel)
        NSLayoutConstraint.activate([
            colorLabel.heightAnchor.constraint(equalToConstant: 16),
            colorLabel.topAnchor.constraint(equalTo: shapesSegmentedControl.bottomAnchor, constant: 32),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // colorsStack
        let colors = [UIColor.Colors.red, UIColor.Colors.orange, UIColor.Colors.yellow, UIColor.Colors.green, UIColor.Colors.teal, UIColor.Colors.blue, UIColor.Colors.purple]
        
        for index in 0...(colors.count - 1) {
            
            let colorButton = ColorButton(frame: .zero)
            colorButton.layer.cornerRadius = 16
            colorButton.layer.masksToBounds = true
            colorButton.backgroundColor = colors[index]
            colorButton.addTarget(self, action: #selector(handleColorChange(_:)), for: .touchUpInside)
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                colorButton.isSelected = true
            } else {
                colorButton.isSelected = false
            }
            
            colorButtons.append(colorButton)
            colorsStack.addArrangedSubview(colorButton)
            
        }
        
        for button in colorsStack.arrangedSubviews {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 32),
                button.heightAnchor.constraint(equalTo: button.widthAnchor)
            ])
        }
        
        view.addSubview(colorsStack)
        NSLayoutConstraint.activate([
            colorsStack.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            colorsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // thicknessLabel
        let thicknessLabel = UILabel(frame: .zero)
        thicknessLabel.text = "THICKNESS"
        thicknessLabel.textColor = .gray
        thicknessLabel.font = UIFont.systemFont(ofSize: 14)
        thicknessLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(thicknessLabel)
        NSLayoutConstraint.activate([
            thicknessLabel.heightAnchor.constraint(equalToConstant: 16),
            thicknessLabel.topAnchor.constraint(equalTo: colorsStack.bottomAnchor, constant: 32),
            thicknessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // thicknessSlider
        let thicknessViewBackgroundView = UIView(frame: .zero)
        thicknessViewBackgroundView.backgroundColor = .clear
        thicknessViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let thicknessSizeBackgroundView = UIView(frame: .zero)
        thicknessSizeBackgroundView.backgroundColor = .clear
        thicknessSizeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(thicknessViewBackgroundView)
        thicknessViewBackgroundView.addSubview(thicknessView)
        view.addSubview(thicknessSizeBackgroundView)
        thicknessSizeBackgroundView.addSubview(thicknessLabel)
        view.addSubview(thicknessSlider)
        NSLayoutConstraint.activate([
            thicknessViewBackgroundView.widthAnchor.constraint(equalToConstant: 32),
            thicknessViewBackgroundView.heightAnchor.constraint(equalTo: thicknessViewBackgroundView.widthAnchor),
            
            thicknessSizeBackgroundView.widthAnchor.constraint(equalToConstant: 32),
            thicknessSizeBackgroundView.heightAnchor.constraint(equalTo: thicknessSizeBackgroundView.widthAnchor),
            
            thicknessSlider.topAnchor.constraint(equalTo: thicknessLabel.bottomAnchor, constant: 32),
            
            thicknessViewBackgroundView.centerYAnchor.constraint(equalTo: thicknessSlider.centerYAnchor),
            thicknessViewBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thicknessView.centerXAnchor.constraint(equalTo: thicknessViewBackgroundView.centerXAnchor),
            thicknessView.centerYAnchor.constraint(equalTo: thicknessViewBackgroundView.centerYAnchor),
            
            thicknessSizeBackgroundView.centerYAnchor.constraint(equalTo: thicknessSlider.centerYAnchor),
            thicknessSizeBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            thicknessLabel.centerXAnchor.constraint(equalTo: thicknessSizeBackgroundView.centerXAnchor),
            thicknessLabel.centerYAnchor.constraint(equalTo: thicknessSizeBackgroundView.centerYAnchor),
            
            thicknessSlider.leadingAnchor.constraint(equalTo: thicknessViewBackgroundView.trailingAnchor, constant: 16),
            thicknessSlider.trailingAnchor.constraint(equalTo: thicknessSizeBackgroundView.leadingAnchor, constant: -16)
        ])
        
        // opacityLabel
        let opacityLabel = UILabel(frame: .zero)
        opacityLabel.text = "OPACITY"
        opacityLabel.textColor = .gray
        opacityLabel.font = UIFont.systemFont(ofSize: 14)
        opacityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(opacityLabel)
        NSLayoutConstraint.activate([
            opacityLabel.heightAnchor.constraint(equalToConstant: 16),
            opacityLabel.topAnchor.constraint(equalTo: thicknessSlider.bottomAnchor, constant: 48),
            opacityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // opacityStack
        let opacities: [CGFloat] = [30, 60, 90]
        
        for index in 0...(opacities.count - 1) {
            
            let opacityButton = OpacityButton(frame: .zero)
            opacityButton.setImage(UIImage(named: "circle"), for: .normal)
            opacityButton.tintColor = UIColor.yellow.withAlphaComponent(opacities[index] / 100)
            opacityButton.setTitle("\(opacities[index])%", for: .normal)
            opacityButton.titleLabel?.textColor = .white
            opacityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            opacityButton.contentHorizontalAlignment = .left
            opacityButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            opacityButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
            
            opacityButton.addTarget(self, action: #selector(handleOpactityChange(_:)), for: .touchUpInside)
            opacityButton.translatesAutoresizingMaskIntoConstraints = false
            
            // FIXME: put title bellow and add image with needed color and opacity instat of background color
            
            if index == 0 {
                opacityButton.isSelected = true
            } else {
                opacityButton.isSelected = false
            }
            
            opacityButtons.append(opacityButton)
            opacitiesStack.addArrangedSubview(opacityButton)
            
        }
        
        view.addSubview(opacitiesStack)
        NSLayoutConstraint.activate([
            opacitiesStack.heightAnchor.constraint(equalToConstant: 44),
            opacitiesStack.topAnchor.constraint(equalTo: opacityLabel.bottomAnchor, constant: 16),
            opacitiesStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            opacitiesStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        prepareBackgroundView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @objc fileprivate func handleColorChange(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            for button in colorButtons {
                button.isSelected = false
            }
            sender.isSelected = true
            
        }
        
        color = sender.backgroundColor ?? .black
        
    }
    
    @objc fileprivate func handleSliderChange(_ sender: UISlider) {
        thicknessSizeLabel.text = String(sender.value)
        thikness = CGFloat(sender.value)
    }
    
    @objc fileprivate func handleOpactityChange(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            for button in opacityButtons {
                button.isSelected = false
            }
            sender.isSelected = true
            
        }
        
        if let number = NumberFormatter().number(from: String(sender.titleLabel!.text!.dropLast())) {
            opacity = CGFloat(truncating: number) / 100
        }
        
    }
    
    @objc fileprivate func changeShspes(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.shapeesParameter(shape: Shapes.line, color: color, width: thikness, opacity: opacity)
        case 1:
            delegate?.shapeesParameter(shape: Shapes.arrow, color: color, width: thikness, opacity: opacity)
        case 2:
            delegate?.shapeesParameter(shape: Shapes.size, color: color, width: thikness, opacity: opacity)
        case 3:
            delegate?.shapeesParameter(shape: Shapes.rectangle, color: color, width: thikness, opacity: opacity)
        case 4:
            delegate?.shapeesParameter(shape: Shapes.circle, color: color, width: thikness, opacity: opacity)
        case 5:
            delegate?.shapeesParameter(shape: Shapes.check, color: color, width: thikness, opacity: opacity)
        case 6:
            delegate?.shapeesParameter(shape: Shapes.cross, color: color, width: thikness, opacity: opacity)
        default:
            return
        }
    }
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        delegate?.cancel()
    }
    
    // MARK: Gestures
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    // MARK: Helper
    
    func prepareBackgroundView() {
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
        
    }
    
    func close() {
        
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
        
    }
    
}

extension ShapesController: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if let touchedView = touch.view, touchedView.isKind(of: UISlider.self) {
            return false
        }

        return true
    }
    
}
