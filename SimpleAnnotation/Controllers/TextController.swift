//
//  TextController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 8/18/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol TextControllerDelegate {
    func textParameter(color: UIColor, backgorundColor: UIColor, size: CGFloat)
    func cancelText()
}

class TextController: UIViewController {
    
    // MARK: Variables
    
    var delegate: TextControllerDelegate?
    
    var color: UIColor = .black {
        didSet {
            delegate?.textParameter(color: color, backgorundColor: backgorundColor, size: size)
        }
    }
    
    var backgorundColor: UIColor = .clear {
        didSet {
            delegate?.textParameter(color: color, backgorundColor: backgorundColor, size: size)
        }
    }
    
    var size: CGFloat = 18.0 {
        didSet {
            delegate?.textParameter(color: color, backgorundColor: backgorundColor, size: size)
        }
    }
    
    var fullView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (sizeStack.frame.maxY + navigationBarHeight)
    }
    
    var partialView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (colorsStack.frame.maxY + navigationBarHeight)
    }
    
    var colorButtons: [ColorButton] = []
    var backgroundColorButtons: [ColorButton] = []
    
    // MARK: Properties
    
    let colorsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "18.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sizeStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.alignment = .center
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
        titleLabel.text = "Text"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: holdView.bottomAnchor, constant: 16)
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
            colorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
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
        
        // backgroundColorLabel
        let backgroundColorLabel = UILabel(frame: .zero)
        backgroundColorLabel.text = "BACKGROUND COLOR"
        backgroundColorLabel.textColor = .gray
        backgroundColorLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundColorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundColorLabel)
        NSLayoutConstraint.activate([
            backgroundColorLabel.heightAnchor.constraint(equalToConstant: 16),
            backgroundColorLabel.topAnchor.constraint(equalTo: colorsStack.bottomAnchor, constant: 32),
            backgroundColorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // backgroundColorsStack
        let backgroundColorsStack = UIStackView(frame: .zero)
        backgroundColorsStack.spacing = 0
        backgroundColorsStack.distribution = .equalSpacing
        backgroundColorsStack.alignment = .center
        backgroundColorsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundColors = [UIColor.black, UIColor.white, UIColor.Colors.red]
        
        for index in 0...(backgroundColors.count - 1) {
            
            let colorButton = ColorButton(frame: .zero)
            colorButton.layer.cornerRadius = 16
            colorButton.layer.masksToBounds = true
            colorButton.backgroundColor = backgroundColors[index]
            colorButton.addTarget(self, action: #selector(handleBackgroundColorChange(_:)), for: .touchUpInside)
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                colorButton.isSelected = true
            } else {
                colorButton.isSelected = false
            }
            
            backgroundColorButtons.append(colorButton)
            backgroundColorsStack.addArrangedSubview(colorButton)
            
        }
        
        for button in backgroundColorsStack.arrangedSubviews {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 32),
                button.heightAnchor.constraint(equalTo: button.widthAnchor)
            ])
        }
        
        view.addSubview(backgroundColorsStack)
        NSLayoutConstraint.activate([
            backgroundColorsStack.topAnchor.constraint(equalTo: backgroundColorLabel.bottomAnchor, constant: 16),
            backgroundColorsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundColorsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // sizeLabel
        let sizeTitleLable = UILabel(frame: .zero)
        sizeTitleLable.text = "SIZE"
        sizeTitleLable.textColor = .gray
        sizeTitleLable.font = UIFont.systemFont(ofSize: 14)
        sizeTitleLable.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sizeTitleLable)
        NSLayoutConstraint.activate([
            sizeTitleLable.heightAnchor.constraint(equalToConstant: 16),
            sizeTitleLable.topAnchor.constraint(equalTo: backgroundColorsStack.bottomAnchor, constant: 32),
            sizeTitleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // sizeStack
        let sizeStepper = UIStepper(frame: .zero)
        sizeStepper.minimumValue = 12
        sizeStepper.maximumValue = 32
        sizeStepper.value = 18
        sizeStepper.stepValue = 2
        sizeStepper.addTarget(self, action: #selector(handleStepperChange(_:)), for: .valueChanged)
        sizeStepper.translatesAutoresizingMaskIntoConstraints = false
        
        sizeStack.addArrangedSubview(sizeLabel)
        sizeStack.addArrangedSubview(sizeStepper)
        
        view.addSubview(sizeStack)
        NSLayoutConstraint.activate([
            sizeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sizeStack.topAnchor.constraint(equalTo: sizeTitleLable.bottomAnchor, constant: 16)
        ])
        
        // closeButton
        let closeButton = UIButton(frame: .zero)
        closeButton.setImage(UIImage(named: "none_w"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
    @objc fileprivate func handleBackgroundColorChange(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            for button in backgroundColorButtons {
                button.isSelected = false
            }
            sender.isSelected = true
            
        }
        
        backgorundColor = sender.backgroundColor ?? .clear
        
    }
    
    @objc fileprivate func handleStepperChange(_ sender: UIStepper) {
        sizeLabel.text = String(sender.value)
        size = CGFloat(sender.value)
    }
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        delegate?.cancelText()
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

extension TextController: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if let touchedView = touch.view, touchedView.isKind(of: UISlider.self) {
            return false
        }

        return true
    }
    
}
